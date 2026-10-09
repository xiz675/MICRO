"""
Correctness test for multiseg_collect.py without Neo4j.

* builds a small synthetic CM-LDBC in PostgreSQL (edge tables, node-type tables, subset-label filter
  tables, pre-filtered property tables);
* FakeNeo4j translates every Cypher the collector produces into SQL over the edge tables (the base
  pattern via generate_equivelent_sql.process_cypher_query, moved :<label>T nodes as the PG tables
  they were loaded from), so table movements and the graph side are emulated faithfully;
* runs the real collector code (RunPlan, SegmentExecutor, compose, run_composite) and checks that
  - all plans of a segment produce identical outputs (seg{i} / R_ia / final result),
  - R_ib's output equals the output of the plans that move seg{i-1},
  - composed latencies follow the DAG formula and validation runs end-to-end in parallel.

Needs a PostgreSQL server: PGHOST / PGPORT / PGUSER / PGDATABASE (default local socket, db ldbc).
    python test_multiseg_collect.py
"""
import json
import os
import random
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [HERE, os.path.join(HERE, "..", "benchmark"), os.path.join(HERE, "..", "benchmark", "ldbc-workload-generation")]

import multiseg_collect as mc                                    # noqa: E402
from multiseg_query_rewrite import decompose_multiseg            # noqa: E402
from llm_multiseg_generation import FEW_SHOT                     # noqa: E402
from generate_equivelent_sql import process_cypher_query         # noqa: E402
from utils.sql_rewrite_util import remove_stars                  # noqa: E402
from utils.pg_utils import PostgresUtil                          # noqa: E402
from utils.run_plan_util import RunPlan                          # noqa: E402

PG = dict(dbname=os.environ.get("PGDATABASE", "ldbc"), user=os.environ.get("PGUSER", "postgres"),
          password=os.environ.get("PGPASSWORD", ""), host=os.environ.get("PGHOST", "/tmp/pgtest_multiseg"))


# ---------------------------------------------------------------------------
# synthetic data
# ---------------------------------------------------------------------------
def build_data(pg: PostgresUtil, seed=0):
    rng = random.Random(seed)
    ids = {}
    base = 0

    def make(kind, n):
        nonlocal base
        ids[kind] = list(range(base + 1, base + n + 1))
        base += 1000
    for kind, n in [("Person", 120), ("Forum", 40), ("Post", 300), ("Comment", 500), ("Tag", 25),
                    ("TagClass", 6), ("City", 15), ("Country", 5), ("Company", 12), ("University", 8)]:
        make(kind, n)
    stmts = []

    def table(name, cols, rows):
        stmts.append(f'DROP TABLE IF EXISTS {name} CASCADE')     # unquoted, like the real T1/T2 databases
        stmts.append(f'CREATE TABLE {name} ({", ".join(c + " " + t for c, t in cols)})')
        if rows:
            vals = ", ".join("(" + ", ".join(repr(v) if isinstance(v, str) else str(v) for v in r) + ")" for r in rows)
            stmts.append(f'INSERT INTO {name} VALUES {vals}')

    def edges(name, a, b, src, dst, per, uniq=True):
        rows = set()
        for s in ids[src]:
            for d in rng.sample(ids[dst], min(per, len(ids[dst]))):
                if src != dst or s != d:
                    rows.add((s, d))
        table(name, [(a, "bigint"), (b, "bigint")], sorted(rows))

    edges("place_ispartof_place", "subreg_id", "reg_id", "City", "Country", 1)
    edges("person_islocatedin_place", "person_id", "loc_id", "Person", "City", 1)
    edges("forum_hasmember_person", "forum_id", "person_id", "Forum", "Person", 12)
    edges("forum_hasmoderator_person", "forum_id", "person_id", "Forum", "Person", 1)
    edges("forum_containerof_message", "forum_id", "post_id", "Forum", "Post", 8)
    msg_tag = set((m, t) for k in ("Post", "Comment") for m in ids[k] for t in rng.sample(ids["Tag"], 2))
    table("message_hastag_tag", [("message_id", "bigint"), ("tag_id", "bigint")], sorted(msg_tag))
    edges("tag_hastype_tagclass", "tag_id", "tagclass_id", "Tag", "TagClass", 1)
    edges("person_hasinterest_tag", "person_id", "tag_id", "Person", "Tag", 3)
    edges("person_workat_organisation", "person_id", "company_id", "Person", "Company", 1)
    edges("person_studyat_organisation", "person_id", "university_id", "Person", "University", 1)
    edges("organisation_islocatedin_place", "org_id", "loc_id", "Company", "Country", 1)
    creator = [(m, rng.choice(ids["Person"])) for k in ("Post", "Comment") for m in ids[k]]
    table("message_hascreator_person", [("message_id", "bigint"), ("person_id", "bigint")], creator)
    reply = [(c, rng.choice(ids["Post"])) for c in ids["Comment"]]
    table("message_replyof_message", [("message_id", "bigint"), ("replied_message_id", "bigint")], reply)
    edges("person_knows_person", "person_id", "friend_id", "Person", "Person", 6)
    edges("person_likes_message", "person_id", "message_id", "Person", "Post", 5)
    # node-type tables used for replaceable labels
    table("place", [("id", "bigint"), ("type", "text")],
          [(i, "City") for i in ids["City"]] + [(i, "Country") for i in ids["Country"]])
    table("organisation", [("id", "bigint"), ("type", "text")],
          [(i, "Company") for i in ids["Company"]] + [(i, "University") for i in ids["University"]])
    table("message", [("id", "bigint"), ("type", "text")],
          [(i, "Post") for i in ids["Post"]] + [(i, "Comment") for i in ids["Comment"]])
    # subset labels (Person1, Forum2, ...) -> filter tables
    for lab, kind in [("person1", "Person"), ("forum1", "Forum"), ("forum2", "Forum"), ("post1", "Post"),
                      ("post2", "Post"), ("comment1", "Comment"), ("comment2", "Comment")]:
        table(f"filter_{lab}", [("id", "bigint")], [(i,) for i in ids[kind] if rng.random() < 0.8])
    # pre-filtered property tables (T1-style): ~70% of the entities survive the "predicates"
    props = {
        "Person": [("firstname", "text"), ("gender", "text"), ("birthday", "text"), ("browserused", "text")],
        "Post": [("creationdate", "text"), ("length", "int")],
        "Comment": [("creationdate", "text"), ("length", "int")],
        "Tag": [("name", "text")], "TagClass": [("name", "text")], "Country": [("name", "text")],
        "City": [("name", "text")], "Forum": [("title", "text")], "Company": [("name", "text")],
        "University": [("name", "text")],
    }
    for kind, cols in props.items():
        rows = []
        for i in ids[kind]:
            if rng.random() < 0.7:
                rows.append((i,) + tuple(rng.randint(1, 500) if t == "int" else f"{c}_{i % 7}" for c, t in cols))
        table(kind, [("id", "bigint")] + cols, rows)
    for s in stmts:
        pg.run_query(s)


# ---------------------------------------------------------------------------
# fake Neo4j
# ---------------------------------------------------------------------------
class FakeNeo4j:
    moved = {}          # label (with T) -> source PG table, shared across executors (threads)

    def __init__(self, pg: PostgresUtil):
        self.pg = pg
        self.executed = []

    def to_sql(self, cypher: str) -> str:
        cypher = remove_stars(cypher)
        parts = re.split(r"(?i)\nRETURN\s+", cypher)
        body, ret = parts[0], parts[1]
        where = ""
        m = re.search(r"(?is)\n(WHERE|AND)\s+(.*)$", body)
        moved = re.findall(r"MATCH \((\w+):(\w+T)\)", body)
        if m and moved:
            where, body = m.group(2), body[:m.start()]
        base_lines = [l for l in body.split("\n") if not re.match(r"MATCH \(\w+:\w+T\)$", l.strip())]
        base = "\n".join(base_lines)
        named = sorted({v for v, _ in re.findall(r"\((\w+)\s*:\s*(\w+)", base)})
        q = base + "\nRETURN " + ", ".join(f"{v}.id as {v}__id" for v in named)
        alias_rels, path_joins, filter_types, sel = process_cypher_query(q)
        base_sql = (f"SELECT {', '.join(f'{c} AS {a}' for a, c in sel.items())} FROM "
                    f"{', '.join(f'{r} {a}' for a, r in alias_rels.items())}" +
                    (" WHERE " + " and ".join(list(filter_types) + [f'{x}={y}' for x, y in path_joins])
                     if filter_types or path_joins else ""))
        frm = [f"({base_sql}) b"] + [f'{self.moved[lab]} {tv}' for tv, lab in moved]

        def tr(expr):
            expr = re.sub(r"\b(\w+)\.id\b", lambda mm: f"b.{mm.group(1)}__id" if mm.group(1) in named else mm.group(0), expr)
            return expr
        items = []
        for it in [x.strip() for x in ret.split(",")]:
            e, a = re.split(r"(?i)\s+as\s+", it)
            items.append(f"{tr(e)} AS {a}")
        conds = [tr(c) for c in re.split(r"(?i)\s+AND\s+", where)] if where else []
        return f"SELECT {', '.join(items)} FROM {', '.join(frm)}" + (f" WHERE {' and '.join(conds)}" if conds else "")

    # --- Neo4jUtil interface used by RunPlan / SegmentExecutor ---
    def run_query(self, query):
        m = re.search(r"'(\w+)'\) YIELD row\",\s*\"CREATE \(x:(\w+)", query, re.S)
        if m:
            self.moved[m.group(2)] = m.group(1)
        self.executed.append(query)

    def run_query_return_single_value(self, query):
        inner = re.search(r'runTimeboxed\("(.*)", \{\}', query, re.S).group(1)
        sql = self.to_sql(re.sub(r"(?is)return count\(\*\)$", "RETURN 1 as one", inner))
        return float(self.pg.run_query_return_result(f"select count(*) from ({sql}) x")[0][0])

    def run_query_stream(self, query, pg_util, max_records=None, table_name="neo4j", **kw):
        # like Neo4jUtil.run_query_stream: errors are logged and None is returned
        try:
            sql = self.to_sql(query)
        except Exception:      # noqa: BLE001
            return None
        pg_util.run_query(f'DROP TABLE IF EXISTS "{table_name}"')
        pg_util.run_query(f'CREATE TABLE "{table_name}" AS {sql}')
        n = pg_util.run_query_return_result(f'select count(*) from "{table_name}"')[0][0]
        return n

    def explain_query_plan(self, query):
        # like EXPLAIN in Neo4j: raises on an invalid query (here: an untranslatable pattern)
        self.to_sql(query)
        return "{}"


def snapshot(pg, sql_or_table):
    q = sql_or_table if sql_or_table.lower().startswith("select") else f'select * from "{sql_or_table}"'
    rows = pg.run_query_return_result(q) or []
    return sorted(tuple(str(x) for x in r) for r in rows)


# ---------------------------------------------------------------------------
def main():
    pg = PostgresUtil(**PG)
    pg.connect()
    build_data(pg)
    random.seed(1)

    def make_executor(timeout_count=True):
        p = PostgresUtil(**PG)
        p.connect()
        return mc.SegmentExecutor(RunPlan(p, FakeNeo4j(p)), timeout_count, keep_result=True)

    seg_ex = make_executor()
    pgx = seg_ex.pg
    failures = 0
    for qi, q in enumerate(FEW_SHOT):
        q = re.sub(r"LIMIT \$\w+", "LIMIT 15", q)
        q = re.sub(r"(>=?) \$n\b", r"\1 2", q)        # HAVING-style thresholds need concrete values
        mq = json.loads(json.dumps(decompose_multiseg(q).__dict__, default=lambda o: o.__dict__))
        stages = [mc.Stage(**s) for s in mq["stages"]]
        k = len(stages)
        parsed = [mc.parse_stage(st, i + 1) for i, st in enumerate(stages)]
        rws = [mc.SegmentRewriter(ps, i == k - 1) for i, ps in enumerate(parsed)]
        plans_by_stage, rib = [], [0.0] * k
        print(f"=== query {qi}: k={k}, plans per segment {[2 ** len(ps.joins) for ps in parsed]}")
        for i, rw in enumerate(rws):
            last = i == k - 1
            outs = {"full": set(), "ra": set()}
            recs = []
            final_sql_out = {}
            for p in rw.plans():
                t = seg_ex.run_plan(p, stages[i].output, last, ra_table=f"r{i + 1}a")
                assert not t.get("empty"), f"query {qi} segment {i + 1}: empty result on synthetic data"
                if p.split:
                    outs["ra"].add(json.dumps(snapshot(pgx, f"r{i + 1}a")))
                elif last:
                    outs["full"].add(json.dumps(sorted(tuple(str(x) for x in r) for r in seg_ex.last_result)))
                else:
                    outs["full"].add(json.dumps(snapshot(pgx, stages[i].output)))
                rec = mc.asdict(p)
                rec["timings"] = t
                recs.append(rec)
            if any(p.split for p in rw.plans()):
                r = seg_ex.run_rib(rw.rib_sql(f"r{i + 1}a"), stages[i].output, last)
                rib[i] = r["rib"]
                rib_out = json.dumps(sorted(tuple(str(x) for x in r) for r in seg_ex.last_result) if last
                                     else snapshot(pgx, stages[i].output))
                ok_rib = outs["full"] == {rib_out}
            else:
                ok_rib = True
            ok = len(outs["full"]) <= 1 and len(outs["ra"]) <= 1 and ok_rib
            failures += not ok
            print(f"  segment {i + 1}: {len(recs)} plans | distinct outputs full={len(outs['full'])} "
                  f"R_ia={len(outs['ra'])} | R_ib == moved-seg output: {ok_rib} -> {'OK' if ok else 'FAIL'}")
            plans_by_stage.append(recs)
        comp = mc.compose(plans_by_stage, rib)
        # spot-check the composition formula on one non-moved and one moved combination
        for c in comp[:1] + comp[-1:]:
            end = 0.0
            for i, pi in enumerate(c["combo"]):
                tm = plans_by_stage[i][pi]["timings"]
                if i == 0:
                    end = tm["pre_base"] + tm["graph"] + tm["sql"]
                elif plans_by_stage[i][pi]["seg_moved"]:
                    end = max(end, tm["pre_base"]) + tm["move_seg"] + tm["graph"] + tm["sql"]
                else:
                    end = max(end, tm["pre_base"] + tm["graph"] + tm["sql"]) + rib[i]
            assert abs(end - c["latency"]) < 1e-9
        sample = random.sample(comp, min(3, len(comp)))
        reals = [mc.run_composite(make_executor, rws, plans_by_stage, c["combo"], [s.output for s in stages])
                 for c in sample]
        print(f"  composite plans: {len(comp)}; validation (composed vs real, s): "
              + ", ".join(f"{c['latency']:.3f}/{r:.3f}" for c, r in zip(sample, reals)))
    failures += test_driver(make_executor)
    print("ALL OK" if failures == 0 else f"{failures} FAILURES")
    sys.exit(1 if failures else 0)


def instantiate(q: str) -> str:
    q = re.sub(r"LIMIT \$\w+", "LIMIT 15", q)
    return re.sub(r"(>=?) \$n\b", r"\1 2", q)


def test_driver(make_executor) -> int:
    """precheck_query + collect_query as main() uses them, including deliberately broken queries."""
    print("=== driver: precheck + consistency")
    ex = make_executor()
    fails = 0

    def mq_of(q):
        return json.loads(json.dumps(decompose_multiseg(instantiate(q)).__dict__, default=lambda o: o.__dict__))

    def expect(name, cond):
        nonlocal fails
        fails += not cond
        print(f"  {name}: {'OK' if cond else 'FAIL'}")

    for qi, q in enumerate(FEW_SHOT):
        mq = mq_of(q)
        rep = mc.precheck_query(mq, ex, keep_params=False)
        rec, _ = mc.collect_query(mq, ex, keep_params=False, repeat=1, dry_run=False)
        expect(f"query {qi} passes precheck and is consistent",
               rep["ok"] and rec["usable_for_training"] and all(c["latency"] is not None for c in rec["composite"]))

    # 1) broken query: relationship type that does not exist -> precheck fails as a query error
    mq = mq_of(FEW_SHOT[1])
    mq["stages"][1]["cypher"] = mq["stages"][1]["cypher"].replace("HAS_TAG", "HAS_TAGG")
    rep = mc.precheck_query(mq, ex, keep_params=False)
    expect(f"invalid relationship type is caught ({rep['reason'][:50]}...)", not rep["ok"] and rep["kind"] == "query")

    # 2) empty seg1: HAVING threshold no group can reach -> precheck fails
    rep = mc.precheck_query(mq_of(FEW_SHOT[1].replace("localMembers > $n", "localMembers > 100000")), ex, False)
    expect(f"empty intermediate result is caught ({rep['reason']})", not rep["ok"] and "empty" in rep["reason"])

    # 3) rewrite bug in one plan (drops a join when Tag0 is moved) -> consistency check flags the query
    orig = mc.SegmentRewriter.rewrite

    def buggy(self, moved):
        p = orig(self, moved)
        if any(m.alias == "Tag0" for m in moved) and self.ps.idx == 2:
            p.cypher = re.sub(r"\nAND [^\n]*|WHERE t\.id = t_tag0\.id( AND )?", lambda m: "WHERE " if m.group(1) else "", p.cypher)
            p.cypher = p.cypher.replace("\nWHERE \nRETURN", "\nRETURN")
        return p
    mc.SegmentRewriter.rewrite = buggy
    try:
        mq = mq_of(FEW_SHOT[0])
        rec, _ = mc.collect_query(mq, ex, keep_params=False, repeat=1, dry_run=False)
    finally:
        mc.SegmentRewriter.rewrite = orig
    expect(f"rewrite bug is flagged ({rec['consistency'][1]})", rec["usable_for_training"] is False)
    return fails


if __name__ == "__main__":
    main()
