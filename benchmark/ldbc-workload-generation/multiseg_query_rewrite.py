"""
Deterministic decomposition of a multi-segment CMGRJ query (written on the virtual graph) into a
chain of (Cypher_i, SQL_i) stages. Each segment reuses rewrite_cypher_to_cypher_and_sql, so the
single-segment semantics are unchanged.

Canonical (plan-agnostic) form for a k-segment query:

    G_1  --neo4j-->  SQL_1  --seg1-->  G_2  --neo4j-->  SQL_2  --seg2--> ... G_k --> SQL_k

* G_i       : segment i's MATCH with table-resident predicates removed; returns node ids.
* SQL_i     : joins G_i's result (table `neo4j`) with the property tables, applies segment i's
              table-resident predicates, and (for i < k) the boundary: GROUP BY / aggregate, the
              WHERE after WITH (HAVING-like), ORDER BY, LIMIT. Its output is table `seg{i}`, holding
              `{var}id` for every carried node variable plus the aggregate aliases.
* For i > 1 : SQL_i additionally joins `seg{i-1}` on the carried variables.

In the canonical form G_i runs *unbound* (the "independent execution" plan). `bound_cypher` gives the
alternative where seg{i-1} is pushed back into Neo4j and G_i starts from those vertices
(`UNWIND $seg{i-1} AS b MATCH (f:Person {id: b.fid}) ...`). Choosing between them per boundary is
MICRO's optimization decision, not part of the benchmark.
"""
import json
import random
import re
import sys
from collections import Counter
from dataclasses import dataclass, field, asdict

from crossmodel_query_rewrite import rewrite_cypher_to_cypher_and_sql, modify_cypher_node_labels
from llm_multiseg_generation import check_multiseg, PROP_MAPPING
from utils.cypher_rewrite_util import VAR_PROP_PATTERN


class _LabelAwarePropMapping(dict):
    """prop_not_in_neo4j indexes by label; subset labels (Person1, Forum2) fall back to the base label."""

    def __missing__(self, key):
        base = re.sub(r'\d+$', '', key)
        if base != key and base in self:
            return self[base]
        raise KeyError(key)


PG_PROPS = _LabelAwarePropMapping(PROP_MAPPING)


@dataclass
class Stage:
    cypher: str                          # canonical graph query of this segment
    sql: str                             # relational query over `neo4j` (+ `seg{i-1}`)
    output: str                          # name of the table this stage produces (seg{i} or "result")
    carried_in: list = field(default_factory=list)   # vars joined from the previous stage
    carried_out: list = field(default_factory=list)  # vars passed to the next stage
    bound_cypher: str = None             # graph query with carried_in pushed back into Neo4j
    path_length: int = 0
    tables_touched: list = field(default_factory=list)


@dataclass
class MultiSegQuery:
    original: str
    k: int
    stages: list
    combined_sql: str                    # all SQL stages as one CTE chain over neo4j1..neo4jk
    full_sql: str = None                 # single-model (all-PostgreSQL) equivalent, for XDB / PG-only runs


def _alias_only(text: str, what: str):
    if text and VAR_PROP_PATTERN.search(text):
        raise ValueError(f"{what} must reference aliases only: {text}")


def _finish_sql(sql: str, idx: int, post_where: str, order_by: str, limit: str, distinct: bool) -> str:
    sql = sql.rstrip()
    if distinct and not sql.lower().startswith("select distinct"):
        sql = "select distinct" + sql[len("select"):]
    if post_where:
        # WHERE after WITH may refer to aggregate aliases -> apply it on top of the grouped result
        sql = f"select * from (\n{sql}\n) b{idx}\nwhere {post_where}"
    if order_by:
        sql += "\n" + order_by
    if limit:
        sql += "\n" + limit
    return sql


def _inject_labels(match_text: str, carried: list, labels: dict) -> str:
    # a carried var re-appears without a label, e.g. `MATCH (f)-[...]`; the old rewriter needs `(f:Person)`
    for v in carried:
        match_text, n = re.subn(rf"\(\s*{re.escape(v)}\s*\)", f"({v}:{labels[v]})", match_text, count=1)
        if n == 0 and not re.search(rf"\(\s*{re.escape(v)}\s*:", match_text):
            raise ValueError(f"carried variable {v} not found in next segment")
    return match_text


def _bind(cypher: str, carried: list, labels: dict, prev: str) -> str:
    bound = cypher
    for v in carried:
        pat = rf"\(\s*{re.escape(v)}\s*:\s*{re.escape(labels[v])}\s*\)"
        bound, n = re.subn(pat, f"({v}:{labels[v]} {{id: b.{v}id}})", bound, count=1)
        if n == 0:
            return None
    return f"UNWIND ${prev} AS b\n" + bound


def decompose_multiseg(query: str, modify_labels: bool = True, expected_k: int = None) -> MultiSegQuery:
    original = query.strip().rstrip(";")
    q = original
    if modify_labels:
        # decide subset labels once for the whole query so carried vars keep the same label
        q = modify_cypher_node_labels(q)
    chk = check_multiseg(q, expected_k)
    if not chk.ok:
        raise ValueError(chk.reason)
    labels = chk.labels
    k = len(chk.segments)

    stages, carried_in = [], []
    for i, seg in enumerate(chk.segments):
        idx = i + 1
        last = idx == k
        match_text = _inject_labels(seg.match_text, carried_in, labels)
        ret_items = chk.return_items if last else seg.with_items
        post_where = "" if last else seg.post_where
        order_by = chk.return_order_by if last else seg.order_by
        limit = chk.return_limit if last else seg.limit
        _alias_only(post_where, "WHERE after WITH")
        _alias_only(order_by, "ORDER BY")

        prev = f"seg{i}"
        extra_from = [prev] if carried_in else None
        extra_where = [f"neo4j.{v}id = {prev}.{v}id" for v in carried_in] or None
        cypher, sql, stats = rewrite_cypher_to_cypher_and_sql(
            f"{match_text}\nRETURN {ret_items}", PG_PROPS, modify_labels=False,
            extra_from=extra_from, extra_where=extra_where)

        # the graph query must return the ids used to join with the previous stage
        cypher = re.sub(r"\n\s*\n", "\n", cypher).strip()
        for v in carried_in:
            if not re.search(rf"\b{re.escape(v)}\.id as {re.escape(v)}id\b", cypher):
                cypher += f", {v}.id as {v}id"
        sql = _finish_sql(sql, idx, post_where, order_by, limit,
                          distinct=(not last and seg.with_distinct))

        stages.append(Stage(
            cypher=cypher, sql=sql, output="result" if last else f"seg{idx}",
            carried_in=list(carried_in), carried_out=[] if last else list(seg.carried),
            bound_cypher=_bind(cypher, carried_in, labels, prev) if carried_in else None,
            path_length=stats.total_path_length, tables_touched=sorted(stats.touched_table_types)))
        carried_in = [] if last else seg.carried

    ctes = []
    for i, st in enumerate(stages[:-1]):
        ctes.append(f"{st.output} AS (\n{re.sub(r'\bneo4j\b', f'neo4j{i + 1}', st.sql)}\n)")
    final = re.sub(r"\bneo4j\b", f"neo4j{k}", stages[-1].sql)
    combined = ("with " + ",\n".join(ctes) + "\n" + final) if ctes else final
    mq = MultiSegQuery(original=original, k=k, stages=stages, combined_sql=combined)
    try:
        mq.full_sql = multiseg_to_sql(mq)
    except Exception:          # translation limits of process_cypher_query (e.g. anonymous-node reuse)
        mq.full_sql = None
    return mq


def _graph_stage_to_sql(cypher: str) -> str:
    """Translate a stage's graph query into SQL over the edge tables (same logic as generate_equivelent_sql)."""
    from generate_equivelent_sql import process_cypher_query
    alias_rels, path_joins, filter_types, select_predicates = process_cypher_query(cypher)
    select = ", ".join(f"{col.lower()} AS {alias.lower()}" for alias, col in select_predicates.items())
    frm = ", ".join(f"{rel.lower()} {alias.lower()}" for alias, rel in alias_rels.items())
    where = list(filter_types) + [f"{a.lower()}={b.lower()}" for a, b in path_joins]
    return f"SELECT {select}\nFROM {frm}" + (("\nWHERE " + " and ".join(where)) if where else "")


def _prefix_property_tables(sql: str) -> str:
    # property tables are r_<label> in the single-model database (see process_sql_query)
    def fix_from(m):
        items = []
        for it in m.group(2).split(","):
            it = it.strip()
            name = it.split()[0]
            if re.fullmatch(r"(neo4j|seg)\d*", name):
                items.append(it)
            else:
                items.append("r_" + it.lower())
        return m.group(1) + ", ".join(items)
    return re.sub(r"(?im)^(from\s+)(.*)$", fix_from, sql)


def multiseg_to_sql(mq: MultiSegQuery):
    """All-SQL equivalent: neo4j_i becomes a CTE over the edge tables. Variable-length paths are not
    translated (same as the single-segment pipeline, which marks them TODO)."""
    if any("*" in st.cypher for st in mq.stages):
        return None
    ctes = []
    for i, st in enumerate(mq.stages):
        idx = i + 1
        ctes.append(f"neo4j{idx} AS (\n{_graph_stage_to_sql(st.cypher)}\n)")
        body = _prefix_property_tables(re.sub(r"\bneo4j\b", f"neo4j{idx}", st.sql))
        if idx < mq.k:
            ctes.append(f"{st.output} AS (\n{body}\n)")
        else:
            return "WITH " + ",\n".join(ctes) + "\n" + body


def to_text(mq: MultiSegQuery) -> str:
    """Human-readable dump in the style of cross_model_queries.txt."""
    out = []
    for i, st in enumerate(mq.stages):
        out.append(f"----- stage {i + 1} -> {st.output} -----")
        out.append(st.cypher)
        out.append("*" * 10)
        out.append(st.sql)
    return "\n".join(out) + "\n" + "#" * 10 + "\n"


if __name__ == "__main__":
    random.seed(0)
    if len(sys.argv) >= 3:
        # python multiseg_query_rewrite.py <llm_output.jsonl> <out_prefix>
        in_path, out_prefix = sys.argv[1], sys.argv[2]
        ok, reasons = [], Counter()
        with open(in_path) as f:
            for line in f:
                rec = json.loads(line)
                try:
                    # a valid query whose k differs from the requested spec is kept (k is recorded);
                    # the k distribution is enforced when sampling train/test, not by discarding LLM output
                    mq = decompose_multiseg(rec["cypher"])
                    ok.append({"nl": rec.get("nl"), "spec": rec.get("spec"),
                               "spec_k_match": rec.get("spec", {}).get("k") == mq.k,
                               "boundary_limits": rec.get("boundary_limits"), **asdict(mq)})
                except (ValueError, KeyError, IndexError) as e:
                    reasons[str(e).split(":")[0]] += 1
        with open(out_prefix + "multiseg_queries.jsonl", "w") as f:
            for r in ok:
                f.write(json.dumps(r) + "\n")
        with open(out_prefix + "multiseg_queries.txt", "w") as f:
            for r in ok:
                f.write(to_text(MultiSegQuery(r["original"], r["k"], [Stage(**s) for s in r["stages"]],
                                              r["combined_sql"], r["full_sql"])))
        with open(out_prefix + "multiseg_queries_full.sql", "w") as f:
            f.write(";\n".join(r["full_sql"] or "TODO" for r in ok))
        print(f"kept {len(ok)}; k distribution {Counter(r['k'] for r in ok)}")
        print("rejected:", dict(reasons))
    else:
        from llm_multiseg_generation import FEW_SHOT
        for q in FEW_SHOT:
            mq = decompose_multiseg(q)
            print("=" * 60)
            print(mq.original)
            print(to_text(mq))
            for st in mq.stages[1:]:
                print("[bound]", st.bound_cypher.replace("\n", " "))
            print("[combined sql]\n" + mq.combined_sql)
            print("[full sql]\n" + str(mq.full_sql))
