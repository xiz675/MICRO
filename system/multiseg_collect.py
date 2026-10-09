"""
Training-data collection for multi-segment CMGRJ queries (TKDE extension).

Plan space
----------
Segment i's movable relations are its vertex-table joins (n_i of them) plus, for i > 1, the previous
segment's result table seg{i-1}. A plan picks a subset to move into Neo4j (same table-movement
mechanism as the ICDE version: apoc.load.jdbc -> :<label>T nodes, joined by property in Cypher).
    total plans = prod_i 2^(n_i + [i>1])
Whether seg{i-1} is moved fixes the dependency structure:
    moved     -> G_i must wait for seg{i-1}                    (sequential)
    not moved -> G_i runs independently; only R_ib joins seg{i-1}  (parallel)

Segment-wise collection (each component is executed once, then composed offline)
------------------------------------------------------------------------------
* segment 1, every plan p: pre (table moves) + G + R                         -> T1(p)
* segment i>1, seg NOT moved, every plan p:
      pre + G + R_ia (neo4j x remaining tables, canonical projection)       -> B_i(p)
  R_ib (R_ia result x seg{i-1}, group/having/order/limit), run once          -> Rb_i
  (R_ia outputs are identical across plans, so R_ib is plan-independent)
* segment i>1, seg moved, every plan p:
      pre_base (+ can overlap with earlier segments) + move seg + G + R     -> S_i(p)
Composition, end_i = time seg{i} is available:
    end_1 = T1(p1)
    end_i = max(end_{i-1}, B_i(p_i)) + Rb_i                          if seg{i-1} not moved
    end_i = max(end_{i-1}, pre_base_i(p_i)) + move_seg + G + R       if seg{i-1} moved
    latency(p_1..p_k) = end_k
Executions per query: sum_i 2^(n_i + [i>1]) + (k-1) instead of prod_i 2^(n_i + [i>1]).

`--validate N` executes N sampled composite plans for real (independent branches in parallel
threads) so the composed estimates can be checked against true end-to-end latency.

Convention (same as run_workload.py on CM-LDBC): `$param` predicates are NOT executed; filters are
realised by the pre-filtered tables of the T1/T2 databases. Use --keep-params for instantiated queries.

    python multiseg_collect.py <multiseg_queries.jsonl> <result_dir> --nj-uri ... --pg-db t1 ...
    python multiseg_collect.py <multiseg_queries.jsonl> <result_dir> --dry-run
"""
import argparse
import itertools
import json
import logging
import os
import random
import re
import sys
import threading
import time
from dataclasses import dataclass, field, asdict

HERE = os.path.dirname(os.path.abspath(__file__))
BENCH = os.path.join(HERE, "..", "benchmark")
sys.path[:0] = [BENCH, os.path.join(BENCH, "ldbc-workload-generation")]
from multiseg_query_rewrite import Stage, _finish_sql  # noqa: E402

LARGE_QUERY_TIME = 10000          # same constants as utils/run_plan_util.py
OUT_OF_TIME_QUERY_TIME = 100000
MAX_RECORDS = 10000000

JOIN_RE = re.compile(r"^\s*neo4j\.(\w+)\s*=\s*(\w+)\.(\w+)\s*$")
VAR_LABEL_RE = re.compile(r"\((\w+)\s*:\s*(\w+)")


# ---------------------------------------------------------------------------
# Parsing a stage produced by the decomposer
# ---------------------------------------------------------------------------
def split_top_level(text: str, sep: str = ",") -> list:
    out, depth, cur = [], 0, ""
    for ch in text:
        depth += ch == "("
        depth -= ch == ")"
        if ch == sep and depth == 0:
            out.append(cur.strip())
            cur = ""
        else:
            cur += ch
    if cur.strip():
        out.append(cur.strip())
    return out


@dataclass
class Movable:
    neo4j_col: str        # column of the graph result, e.g. "pid"
    alias: str            # SQL alias, e.g. "Person0" / "seg1"
    table: str            # PG table, e.g. "Person" / "seg1"
    table_col: str        # join column on the table side: "id" / "fid"
    is_seg: bool
    var: str = ""         # Cypher variable whose id is joined, e.g. "p"
    var_label: str = ""


@dataclass
class ParsedStage:
    idx: int
    cypher_match: str
    return_items: list
    select: list
    from_tables: dict     # alias -> table (excluding neo4j)
    joins: list           # Movable
    other_where: list     # non-movable, non-param predicates
    param_where: list     # `$param` predicates
    group_by: list
    stage: Stage

    @property
    def seg(self):
        return next((m for m in self.joins if m.is_seg), None)

    @property
    def base_movables(self):
        return [m for m in self.joins if not m.is_seg]


def parse_stage(stage: Stage, idx: int) -> ParsedStage:
    parts = re.split(r"(?i)\breturn\b", stage.cypher)
    cypher_match, ret = "RETURN".join(parts[:-1]).strip(), parts[-1]
    return_items = split_top_level(ret)
    col_to_var = {}
    for it in return_items:
        m = re.match(r"(\w+)\.id\s+as\s+(\w+)$", it.strip(), re.I)
        if m:
            col_to_var[m.group(2)] = m.group(1)
    var_labels = {v: l for v, l in VAR_LABEL_RE.findall(cypher_match)}

    lines = {}
    for line in stage.core_sql.split("\n"):
        kw = re.match(r"(?i)\s*(select|from|where|group by)\b", line)
        if kw:
            lines[kw.group(1).lower()] = line[kw.end():].strip()
    select = split_top_level(lines["select"])
    from_tables = {}
    for it in split_top_level(lines["from"]):
        toks = it.split()
        if toks[0] == "neo4j":
            continue
        from_tables[toks[-1]] = toks[0]
    joins, other, params = [], [], []
    for pred in re.split(r"(?i)\s+and\s+", lines.get("where", "")) if lines.get("where") else []:
        m = JOIN_RE.match(pred)
        if m and m.group(2) in from_tables:
            col, alias, tcol = m.groups()
            is_seg = re.fullmatch(r"seg\d+", alias) is not None
            var = col_to_var.get(col, "")
            joins.append(Movable(col, alias, from_tables[alias], tcol, is_seg, var, var_labels.get(var, "")))
        elif "$" in pred:
            params.append(pred)
        else:
            other.append(pred)
    group_by = split_top_level(lines["group by"]) if "group by" in lines else []
    return ParsedStage(idx, cypher_match, return_items, select, from_tables, joins, other, params, group_by, stage)


# ---------------------------------------------------------------------------
# Plan rewriting
# ---------------------------------------------------------------------------
def _tvar(alias: str) -> str:
    return "t_" + alias.lower()


def _label(stage_idx: int, alias: str) -> str:
    # run_table_movement_query appends "T"; labels are stage-prefixed so parallel branches never clash
    return f"S{stage_idx}{alias}"


def _refs(text: str, alias: str) -> set:
    return set(re.findall(rf"\b{re.escape(alias)}\.(\w+)", text))


def _sub_refs(text: str, mapping: dict) -> str:
    """mapping: alias -> function(col) -> replacement"""
    for alias, fn in mapping.items():
        text = re.sub(rf"\b{re.escape(alias)}\.(\w+)", lambda m: fn(m.group(1)), text)
    return text


@dataclass
class SegmentPlan:
    stage_idx: int
    moved: list                      # aliases moved to Neo4j
    seg_moved: bool
    split: bool                      # True -> R_ia here, R_ib shared
    cypher: str
    sql: str                         # full SQL (or R_ia when split)
    move_base: list                  # [(table, label, cols)] for run_table_movement_query
    move_seg: list
    plan_tuples: list                # ICDE-format tuples for the feature extractor
    timings: dict = field(default_factory=dict)


class SegmentRewriter:
    def __init__(self, ps: ParsedStage, last: bool, keep_params: bool = False):
        self.ps, self.last, self.keep_params = ps, last, keep_params
        st = ps.stage
        self.post = dict(post_where=st.post_where, order_by=st.order_by, limit=st.limit, distinct=st.distinct)
        # text whose column references must survive (everything except the movable joins)
        self.ref_text = " ".join(ps.select + ps.group_by + ps.other_where +
                                 (ps.param_where if keep_params else []))
        # canonical projection for the split (R_ia -> R_ib); fixed across plans
        self.canon = []      # (sql ref in the un-moved query, canonical name)
        seen = set()
        for alias in ["neo4j"] + [a for a in ps.from_tables if not re.fullmatch(r"seg\d+", a)]:
            for col in sorted(_refs(self.ref_text, alias)):
                name = col if alias == "neo4j" else f"{alias}__{col}"
                if name not in seen:
                    seen.add(name)
                    self.canon.append((alias, col, name))
        if ps.seg and ps.seg.neo4j_col not in seen:
            self.canon.append(("neo4j", ps.seg.neo4j_col, ps.seg.neo4j_col))

    def plans(self) -> list:
        return [self.rewrite(list(c)) for r in range(len(self.ps.joins) + 1)
                for c in itertools.combinations(self.ps.joins, r)]

    def _cypher(self, moved: list, needed_neo4j_cols: set, moved_cols: dict) -> str:
        ps = self.ps
        matches, conds, rets = [ps.cypher_match], [], []
        for m in moved:
            tv = _tvar(m.alias)
            matches.append(f"MATCH ({tv}:{_label(ps.idx, m.alias)}T)")
            conds.append(f"{m.var}.id = {tv}.{m.table_col}")
            rets += [f"{tv}.{c} as {tv}{c}" for c in sorted(moved_cols[m.alias])]
        for it in ps.return_items:
            mm = re.match(r"\w+\.id\s+as\s+(\w+)$", it.strip(), re.I)
            if mm and mm.group(1) not in needed_neo4j_cols:
                continue      # join-only column, the join now happens in Neo4j
            rets.append(it)
        if not rets:
            rets = ps.return_items[:1]
        text = "\n".join(matches)
        if conds:
            # append to an existing WHERE of the last MATCH block, otherwise add one
            text += ("\nAND " if re.search(r"(?i)\bwhere\b", ps.cypher_match.split("MATCH")[-1]) else "\nWHERE ") \
                    + " AND ".join(conds)
        return text + "\nRETURN " + ", ".join(rets)

    def rewrite(self, moved: list) -> SegmentPlan:
        ps = self.ps
        moved_aliases = {m.alias for m in moved}
        seg = ps.seg
        seg_moved = seg is not None and seg.alias in moved_aliases
        split = seg is not None and not seg_moved
        # columns each moved table must ship to Neo4j
        moved_cols = {m.alias: _refs(self.ref_text, m.alias) - {m.table_col} for m in moved}
        sub = {m.alias: (lambda tv: (lambda c: f"neo4j.{tv}{c}"))(_tvar(m.alias)) for m in moved}
        remaining = {a: t for a, t in ps.from_tables.items() if a not in moved_aliases}
        rem_joins = [f"neo4j.{m.neo4j_col} = {m.alias}.{m.table_col}" for m in ps.joins if m.alias not in moved_aliases]
        where = rem_joins + [_sub_refs(p, sub) for p in ps.other_where]
        if self.keep_params:
            where += [_sub_refs(p, sub) for p in ps.param_where]

        if split:
            # R_ia: neo4j x remaining base tables (no seg), canonical projection
            sel = []
            for alias, col, name in self.canon:
                if alias == "neo4j":
                    sel.append(f"neo4j.{col} AS {name}")
                elif alias in moved_aliases:
                    sel.append(f"neo4j.{_tvar(alias)}{col} AS {name}")
                else:
                    sel.append(f"{alias}.{col} AS {name}")
            frm = ["neo4j"] + [f"{t} {a}" for a, t in remaining.items() if a != seg.alias]
            where = [w for w in where if not re.search(rf"\b{seg.alias}\.", w)]
            sql = f"select {', '.join(sel)}\nfrom {', '.join(frm)}" + (f"\nwhere {' and '.join(where)}" if where else "")
        else:
            sel = [_sub_refs(s, sub) for s in ps.select]
            grp = [_sub_refs(g, sub) for g in ps.group_by]
            frm = ["neo4j"] + [f"{t} {a}" for a, t in remaining.items()]
            sql = (f"select {', '.join(sel)}\nfrom {', '.join(frm)}" +
                   (f"\nwhere {' and '.join(where)}" if where else "") +
                   (f"\ngroup by {', '.join(grp)}" if grp else ""))
            sql = _finish_sql(sql, ps.idx, **self.post)

        needed = set(re.findall(r"\bneo4j\.(\w+)", sql))
        cypher = self._cypher(moved, needed, moved_cols)
        move_base = [(m.table, _label(ps.idx, m.alias), sorted(moved_cols[m.alias] | {m.table_col}))
                     for m in moved if not m.is_seg]
        move_seg = [(m.table, _label(ps.idx, m.alias), sorted(moved_cols[m.alias] | {m.table_col}))
                    for m in moved if m.is_seg]
        tuples = [(f"{m.var}.id", f"{m.alias}.{m.table_col}", m.var_label, "SEG" if m.is_seg else m.table)
                  for m in moved]
        return SegmentPlan(ps.idx, sorted(moved_aliases), seg_moved, split, cypher, sql,
                           move_base, move_seg, tuples)

    def rib_sql(self, ra_table: str) -> str:
        """R_ib: shared final step for all plans that do not move seg (canonical names)."""
        ps, seg = self.ps, self.ps.seg
        names = {(a, c): n for a, c, n in self.canon}
        sub = {a: (lambda al: (lambda c: f"ra.{names[(al, c)]}"))(a)
               for a in ["neo4j"] + [x for x in ps.from_tables if x != seg.alias]}
        sel = [_sub_refs(s, sub) for s in ps.select]
        grp = [_sub_refs(g, sub) for g in ps.group_by]
        where = [f"ra.{seg.neo4j_col} = {seg.alias}.{seg.table_col}"] + \
                [_sub_refs(p, sub) for p in ps.other_where]
        sql = (f"select {', '.join(sel)}\nfrom {ra_table} ra, {seg.table} {seg.alias}\nwhere {' and '.join(where)}" +
               (f"\ngroup by {', '.join(grp)}" if grp else ""))
        return _finish_sql(sql, ps.idx, **self.post)


# ---------------------------------------------------------------------------
# Execution
# ---------------------------------------------------------------------------
def _rename_tables(sql: str, mapping: dict) -> str:
    for old, new in mapping.items():
        sql = re.sub(rf"\b{old}\b", new, sql)
    return sql


class SegmentExecutor:
    def __init__(self, executor, timeout_count=True, keep_result=False):
        self.ex = executor            # utils.run_plan_util.RunPlan
        self.pg, self.nj = executor.pg_util, executor.neo4j_util
        self.timeout_count = timeout_count
        self.keep_result = keep_result    # keep the last final result (tests / result checks)
        self.last_result = None

    def _timed(self, fn, *a, **kw):
        t = time.time()
        out = fn(*a, **kw)
        return time.time() - t, out

    def run_graph(self, cypher: str, table: str):
        """count check (like RunPlan.run_plan), then stream the result into `table`."""
        if self.timeout_count:
            try:
                count_q = re.sub(r"(?is)\breturn\b.*$", "return count(*)", cypher)
                size = self.nj.run_query_return_single_value(
                    f"CALL apoc.cypher.runTimeboxed(\"{count_q}\", {{}}, 240000)")
                if size is None:
                    return OUT_OF_TIME_QUERY_TIME, 0
                if size > MAX_RECORDS:
                    return LARGE_QUERY_TIME, int(size)
            except Exception as e:
                logging.info(f"count query failed: {e}")
                return OUT_OF_TIME_QUERY_TIME, 0
        self.pg.run_query(f'DROP TABLE IF EXISTS "{table}"')
        t, rows = self._timed(self.nj.run_query_stream, cypher, self.pg, max_records=MAX_RECORDS, table_name=table)
        return t, rows or 0

    def run_plan(self, plan: SegmentPlan, output: str, last: bool, ra_table: str = None) -> dict:
        tm = {}
        labels = [l for _, l, _ in plan.move_base + plan.move_seg]
        try:
            tm["pre_base"], _ = self._timed(self.ex.run_table_movement_query, plan.move_base)
            tm["move_seg"], _ = self._timed(self.ex.run_table_movement_query, plan.move_seg)
            tm["graph"], tm["graph_rows"] = self.run_graph(plan.cypher, "neo4j")
            if tm["graph"] >= LARGE_QUERY_TIME:
                tm["timeout"] = True
                return tm
            if tm["graph_rows"] == 0:
                # empty graph result -> empty query result; the workload filter should have removed such queries
                tm["sql"], tm["sql_rows"], tm["empty"] = 0.0, 0, True
                return tm
            target = ra_table if plan.split else (None if last else output)
            if target:
                self.pg.run_query(f'DROP TABLE IF EXISTS "{target}"')
                tm["sql"], _ = self._timed(self.pg.run_query, f'CREATE TABLE "{target}" AS\n{plan.sql}')
                tm["sql_rows"] = self.pg.run_query_return_result(f'select count(*) from "{target}"')[0][0]
            else:
                tm["sql"], res = self._timed(self.pg.run_query_return_result, plan.sql)
                tm["sql_rows"] = 0 if res is None else len(res)
                if self.keep_result:
                    self.last_result = res
        finally:
            self.ex.clean_data(set(labels))
        return tm

    def run_rib(self, sql: str, output: str, last: bool) -> dict:
        if not self.pg.run_query_return_result(f"select to_regclass('{re.search(r'from (\w+) ra', sql).group(1)}')")[0][0]:
            return {"rib": 0.0, "rows": 0, "empty": True}
        if last:
            t, res = self._timed(self.pg.run_query_return_result, sql)
            if self.keep_result:
                self.last_result = res
            return {"rib": t, "rows": 0 if res is None else len(res)}
        self.pg.run_query(f'DROP TABLE IF EXISTS "{output}"')
        t, _ = self._timed(self.pg.run_query, f'CREATE TABLE "{output}" AS\n{sql}')
        return {"rib": t, "rows": self.pg.run_query_return_result(f'select count(*) from "{output}"')[0][0]}


# ---------------------------------------------------------------------------
# Offline composition
# ---------------------------------------------------------------------------
def _cap(t):
    return min(t, OUT_OF_TIME_QUERY_TIME)


def segment_cost(p: dict) -> dict:
    t = p["timings"]
    if t.get("timeout"):
        return {"timeout": True}
    return {"pre_base": t.get("pre_base", 0), "move_seg": t.get("move_seg", 0),
            "graph": t.get("graph", 0), "sql": t.get("sql", 0)}


def compose(stage_plans: list, rib: list) -> list:
    """stage_plans[i]: list of plan dicts (with timings) for segment i; rib[i]: R_ib time (i>0)."""
    out = []
    for combo in itertools.product(*[range(len(s)) for s in stage_plans]):
        end, timeout = 0.0, False
        for i, pi in enumerate(combo):
            p = stage_plans[i][pi]
            c = segment_cost(p)
            if c.get("timeout"):
                timeout = True
                break
            if i == 0:
                end = c["pre_base"] + c["graph"] + c["sql"]
            elif p["seg_moved"]:
                end = max(end, c["pre_base"]) + c["move_seg"] + c["graph"] + c["sql"]
            else:
                end = max(end, c["pre_base"] + c["graph"] + c["sql"]) + rib[i]
        out.append({"combo": list(combo), "latency": OUT_OF_TIME_QUERY_TIME if timeout else _cap(end),
                    "timeout": timeout})
    return out


# ---------------------------------------------------------------------------
# Validation: run a composite plan for real, independent branches in parallel
# ---------------------------------------------------------------------------
def run_composite(make_executor, rewriters, plans_by_stage, combo, outputs) -> float:
    """make_executor() -> SegmentExecutor with its own PG connection (psycopg2 is not thread-safe)."""
    k = len(combo)
    done = [threading.Event() for _ in range(k)]
    errors = []
    # connections are opened before the clock starts; no count pre-check (not part of the composed time)
    executors = [make_executor(timeout_count=False) for _ in range(k)]

    def branch(i):
        try:
            ex = executors[i]
            p = plans_by_stage[i][combo[i]]
            plan = SegmentPlan(**{f: p[f] for f in SegmentPlan.__dataclass_fields__ if f in p})
            last = i == k - 1
            nj_table = f"neo4j_s{i + 1}"
            ren = {"neo4j": nj_table}
            sql = _rename_tables(plan.sql, ren)
            ex.ex.run_table_movement_query(plan.move_base)
            if i > 0 and plan.seg_moved:
                done[i - 1].wait()
                ex.ex.run_table_movement_query(plan.move_seg)
            ex.run_graph(plan.cypher, nj_table)
            if plan.split:
                ra = f"r{i + 1}a"
                ex.pg.run_query(f'DROP TABLE IF EXISTS "{ra}"')
                ex.pg.run_query(f'CREATE TABLE "{ra}" AS\n{sql}')
                done[i - 1].wait()
                rib = rewriters[i].rib_sql(ra)
                if last:
                    ex.pg.run_query_return_result(rib)
                else:
                    ex.pg.run_query(f'DROP TABLE IF EXISTS "{outputs[i]}"')
                    ex.pg.run_query(f'CREATE TABLE "{outputs[i]}" AS\n{rib}')
            elif last:
                ex.pg.run_query_return_result(sql)
            else:
                ex.pg.run_query(f'DROP TABLE IF EXISTS "{outputs[i]}"')
                ex.pg.run_query(f'CREATE TABLE "{outputs[i]}" AS\n{sql}')
        except Exception as e:      # noqa: BLE001
            errors.append(e)
        finally:
            finish[i] = time.time()
            done[i].set()

    finish = [0.0] * k
    threads = [threading.Thread(target=branch, args=(i,)) for i in range(k)]
    t = time.time()
    for th in threads:
        th.start()
    for th in threads:
        th.join()
    elapsed = finish[-1] - t          # the last segment produces the final result
    # clean-up happens outside the measured interval
    for i, ex in enumerate(executors):
        p = plans_by_stage[i][combo[i]]
        ex.ex.clean_data({l for _, l, _ in p["move_base"] + p["move_seg"]})
        ex.pg.run_query(f'DROP TABLE IF EXISTS "neo4j_s{i + 1}"')
        ex.pg.disconnect()
    if errors:
        raise errors[0]
    return elapsed


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------
def collect_query(mq: dict, seg_ex: SegmentExecutor, keep_params: bool, repeat: int, dry_run: bool):
    stages = [Stage(**s) for s in mq["stages"]]
    k = len(stages)
    parsed = [parse_stage(st, i + 1) for i, st in enumerate(stages)]
    rewriters = [SegmentRewriter(ps, i == k - 1, keep_params) for i, ps in enumerate(parsed)]
    plans_by_stage, rib_time, rib_rec, raw_plans = [], [0.0] * k, {}, []
    # segments are processed in order so that seg{i-1} is materialised before segment i's moved-seg plans
    for i, rw in enumerate(rewriters):
        last = i == k - 1
        plans = rw.plans()
        recs = []
        for p in plans:
            rec = asdict(p)
            if not dry_run:
                runs = [seg_ex.run_plan(p, stages[i].output, last, ra_table=f"r{i + 1}a") for _ in range(repeat)]
                rec["timings"] = _median_timings(runs)
            recs.append(rec)
        if any(p.split for p in plans):
            # R_ib is shared by all plans that do not move seg{i}; it also materialises seg{i} for the next segment
            sql = rw.rib_sql(f"r{i + 1}a")
            rib_rec[i + 1] = {"sql": sql}
            if not dry_run:
                runs = [seg_ex.run_rib(sql, stages[i].output, last) for _ in range(repeat)]
                rib_rec[i + 1].update(_median_timings(runs))
                rib_time[i] = rib_rec[i + 1]["rib"]
        if not dry_run:
            try:
                raw_plans.append(seg_ex.nj.explain_query_plan(stages[i].cypher))
            except Exception as e:     # noqa: BLE001
                raw_plans.append(None)
                logging.info(f"explain failed: {e}")
        plans_by_stage.append(recs)
    composite = [] if dry_run else compose(plans_by_stage, rib_time)
    n_exec = sum(len(s) for s in plans_by_stage) + len(rib_rec)
    return {"original": mq["original"], "k": k, "segments": plans_by_stage, "rib": rib_rec,
            "neo4j_raw_plans": raw_plans, "composite": composite, "executions": n_exec}, rewriters


def _median_timings(runs: list) -> dict:
    out = {}
    for key in runs[0]:
        vals = [r.get(key) for r in runs]
        if all(isinstance(v, (int, float)) and not isinstance(v, bool) for v in vals):
            vals = sorted(vals)
            out[key] = vals[len(vals) // 2]
        else:
            out[key] = vals[0]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("queries", help="multiseg_queries.jsonl from multiseg_query_rewrite.py")
    ap.add_argument("result_dir")
    ap.add_argument("--dry-run", action="store_true", help="enumerate and print plans, no database")
    ap.add_argument("--keep-params", action="store_true", help="execute $param predicates (instantiated queries)")
    ap.add_argument("--repeat", type=int, default=1)
    ap.add_argument("--validate", type=int, default=0, help="composite plans per query to run end-to-end")
    ap.add_argument("--nj-uri", default="localhost")
    ap.add_argument("--nj-db", default="neo4j")
    ap.add_argument("--nj-user", default="neo4j")
    ap.add_argument("--nj-pw", default=os.environ.get("NEO4J_PASSWORD", "neo4j"))
    ap.add_argument("--pg-host", default="localhost")
    ap.add_argument("--pg-db", default="postgres")
    ap.add_argument("--pg-user", default="postgres")
    ap.add_argument("--pg-pw", default=os.environ.get("PG_PASSWORD", "postgres"))
    ap.add_argument("--log-file", default="multiseg_collect.log")
    args = ap.parse_args()
    logging.basicConfig(filename=args.log_file, level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
    os.makedirs(args.result_dir, exist_ok=True)

    seg_ex, make_executor = None, None
    if not args.dry_run:
        from utils.neo4j_utils import Neo4jUtil
        from utils.pg_utils import PostgresUtil
        from utils.run_plan_util import RunPlan

        def make_executor(timeout_count=True):
            nj = Neo4jUtil(f"bolt://{args.nj_uri}", args.nj_user, args.nj_pw, args.nj_db)
            pg = PostgresUtil(args.pg_db, args.pg_user, args.pg_pw, args.pg_host)
            pg.connect()
            return SegmentExecutor(RunPlan(pg, nj), timeout_count)
        seg_ex = make_executor()

    queries = [json.loads(l) for l in open(args.queries)]
    out_path = os.path.join(args.result_dir, "multiseg_plans_with_runtime.jsonl")
    with open(out_path, "w") as out:
        for qi, mq in enumerate(queries):
            logging.info(f"============= query {qi} =============")
            if any("$" in st["cypher"] for st in mq["stages"]):
                # a predicate on a graph-resident property (id) is left in the Cypher and needs a value
                print(f"[skip] query {qi}: Cypher still contains $params; instantiate it first")
                continue
            if any("$" in st[f] for st in mq["stages"] for f in ("post_where", "order_by", "limit")):
                # LIMIT / HAVING-style thresholds define the query and cannot be dropped like $param filters
                print(f"[skip] query {qi}: boundary LIMIT/threshold still has $params; instantiate it first")
                continue
            rec, rewriters = collect_query(mq, seg_ex, args.keep_params, args.repeat, args.dry_run)
            rec["query_id"] = qi
            if args.dry_run:
                sizes = [len(s) for s in rec["segments"]]
                total = 1
                for n in sizes:
                    total *= n
                print(f"=== query {qi}: k={rec['k']}, plans per segment {sizes}, "
                      f"composite plans {total}, executions {rec['executions']}")
            if args.validate and not args.dry_run and rec["composite"]:
                outputs = [s["output"] for s in mq["stages"]]
                sample = random.sample(rec["composite"], min(args.validate, len(rec["composite"])))
                rec["validation"] = []
                for c in sample:
                    if c["timeout"]:
                        continue
                    real = run_composite(make_executor, rewriters, rec["segments"], c["combo"], outputs)
                    rec["validation"].append({"combo": c["combo"], "composed": c["latency"], "real": real})
            out.write(json.dumps(rec) + "\n")
            out.flush()
    print(f"wrote {out_path}")


if __name__ == "__main__":
    main()
