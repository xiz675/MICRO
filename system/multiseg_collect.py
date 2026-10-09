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

Movement reuse (default; --no-movement-reuse gives the per-plan baseline)
------------------------------------------------------------------------
Moving a relation costs the same whichever plan moves it, so movement is also collected per component:
* each (table, column set) is loaded `--movement-repeat` times into a scratch label, the median time
  is cached in result_dir/movement_cache.json (shared across queries and runs);
* base tables stay in Neo4j under one persistent label per table (MS_<table>T, union of needed columns);
  plans never reload them (`--reset-persistent` after switching T1/T2 or reloading Neo4j);
* seg{i-1} is loaded once per segment and deleted when the query is finished.
Movement time still enters every composed latency (pre_base / move_seg); only its execution is shared.
Per-plan movement and validation use private labels (P_*, V<i>_*), so they never touch MS_* nodes.

`--validate N` executes N sampled composite plans for real (independent branches in parallel
threads) so the composed estimates can be checked against true end-to-end latency. Validation runs after
the collection, on a clean graph (persistent nodes removed), with the real load/delete-per-plan flow;
results go to result_dir/validation.jsonl and the median relative error to the summary.

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


def _label(stage_idx: int, m) -> str:
    """Node label of a moved relation (run_table_movement_query appends "T").
    Base tables share one label per table (MS_<table>), so their nodes can stay in Neo4j across plans and
    queries; seg{i-1} gets a per-segment label and lives for one query."""
    return f"S{stage_idx}{m.alias}" if m.is_seg else f"MS_{m.table}"


def relabel(cypher: str, moves: list, prefix: str):
    """Give moved relations private labels (per-plan movement, validation) so they never touch the
    persistent MS_<table>T nodes of the movement-reuse mode."""
    for _, label, _ in moves:
        cypher = cypher.replace(f":{label}T)", f":{prefix}{label}T)")
    return cypher, [(t, f"{prefix}{l}", c) for t, l, c in moves]


def dedup_moves(moves: list) -> list:
    """One load per label: two aliases of the same table (Person0, Person1) share the moved nodes."""
    merged = {}
    for table, label, cols in moves:
        t, c = merged.get(label, (table, set()))
        merged[label] = (t, c | set(cols))
    return [(t, l, sorted(c)) for l, (t, c) in merged.items()]


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
            matches.append(f"MATCH ({tv}:{_label(ps.idx, m)}T)")
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
        move_base = dedup_moves([(m.table, _label(ps.idx, m), sorted(moved_cols[m.alias] | {m.table_col}))
                                 for m in moved if not m.is_seg])
        move_seg = [(m.table, _label(ps.idx, m), sorted(moved_cols[m.alias] | {m.table_col}))
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


def py_checksum(rows) -> list:
    """order-independent (count, hash) of a fetched result"""
    import hashlib
    h = 0
    for r in rows or []:
        d = hashlib.md5(str(tuple(str(x) for x in r)).encode()).digest()
        h = (h + int.from_bytes(d[:8], "little")) % (1 << 63)
    return [len(rows or []), h]


class MovementManager:
    """Component-wise collection of relation movements (PG -> Neo4j).

    * movement time is measured once per (database, table, column set): `repeat` timed loads into a
      scratch label (each deleted afterwards), median kept, cached in a JSON file across runs;
    * base tables are kept in Neo4j under one persistent label per table (MS_<table>T), loaded with the
      union of the columns needed so far, so plans never reload them;
    * seg{i-1} is loaded once per segment (also timed with `repeat`) and deleted when the query is done.
    Movement time is still part of every composed latency; only the execution is shared.
    """

    def __init__(self, run_plan, cache_path: str, db_key: str, repeat: int = 3):
        self.ex, self.cache_path, self.db_key, self.repeat = run_plan, cache_path, db_key, repeat
        self.state = {"times": {}, "persistent": {}}
        if cache_path and os.path.exists(cache_path):
            with open(cache_path) as f:
                self.state.update(json.load(f))
        self.persistent = self.state["persistent"].setdefault(db_key, {})
        self.seg_loaded = {}          # label -> measured seconds (current query)
        self.hits = self.misses = 0

    def _save(self):
        if self.cache_path:
            with open(self.cache_path, "w") as f:
                json.dump(self.state, f, indent=1)

    def _measure(self, table: str, cols: list) -> float:
        samples = []
        for _ in range(self.repeat):
            t = time.time()
            self.ex.run_table_movement_query([(table, f"MT_{table}", sorted(cols))])
            samples.append(time.time() - t)
            self.ex.clean_data({f"MT_{table}"})
        return sorted(samples)[len(samples) // 2]

    def move_time(self, table: str, cols: list) -> float:
        key = f"{self.db_key}|{table}|{','.join(sorted(cols))}"
        if key in self.state["times"]:
            self.hits += 1
        else:
            self.misses += 1
            self.state["times"][key] = self._measure(table, cols)
            self._save()
        return self.state["times"][key]

    def ensure_persistent(self, table: str, label: str, cols: list):
        loaded = set(self.persistent.get(table, []))
        if set(cols) <= loaded:
            return
        union = sorted(loaded | set(cols))
        if loaded:
            self.ex.clean_data({label})
        self.ex.run_table_movement_query([(table, label, union)])
        self.persistent[table] = union
        self._save()

    def seg_time(self, table: str, label: str, cols: list) -> float:
        if label not in self.seg_loaded:
            self.seg_loaded[label] = self._measure(table, cols)
            self.ex.run_table_movement_query([(table, label, sorted(cols))])
        return self.seg_loaded[label]

    def end_query(self):
        if self.seg_loaded:
            self.ex.clean_data(set(self.seg_loaded))
        self.seg_loaded = {}

    def drop_persistent(self):
        if self.persistent:
            self.ex.clean_data({f"MS_{t}" for t in self.persistent})
        self.persistent.clear()
        self._save()


class SegmentExecutor:
    """Runs one segment plan and records component times, row counts, errors and an output checksum.

    The original utils swallow errors (PostgresUtil logs and rolls back, run_query_stream returns None),
    so errors are detected explicitly: a None from run_query_stream / run_query_return_result, or a
    CREATE TABLE ... AS whose table does not exist afterwards.
    """

    def __init__(self, executor, timeout_count=True, keep_result=False, checksum=True, mover=None):
        self.ex = executor            # utils.run_plan_util.RunPlan
        self.mover = mover            # MovementManager -> reuse movements; None -> load/delete per plan
        self.pg, self.nj = executor.pg_util, executor.neo4j_util
        self.timeout_count = timeout_count
        self.keep_result = keep_result    # keep the last final result (tests)
        self.checksum = checksum
        self.last_result = None

    def _timed(self, fn, *a, **kw):
        t = time.time()
        out = fn(*a, **kw)
        return time.time() - t, out

    def _exists(self, table: str) -> bool:
        r = self.pg.run_query_return_result(f"select to_regclass('\"{table}\"')")
        return bool(r and r[0][0])

    def pg_checksum(self, table: str) -> list:
        r = self.pg.run_query_return_result(
            f'select count(*), coalesce(sum(hashtext(t::text)::bigint), 0) from "{table}" t')
        return [int(r[0][0]), int(r[0][1]) % (1 << 63)] if r else None

    def run_graph(self, cypher: str, table: str):
        """count check (like RunPlan.run_plan), then stream the result into `table`.
        Returns (seconds, rows, status) with status in {ok, timeout, too_large, error}."""
        if self.timeout_count:
            try:
                count_q = re.sub(r"(?is)\breturn\b.*$", "return count(*)", cypher)
                size = self.nj.run_query_return_single_value(
                    f"CALL apoc.cypher.runTimeboxed(\"{count_q}\", {{}}, 240000)")
                if size is None:
                    return OUT_OF_TIME_QUERY_TIME, 0, "timeout"
                if size > MAX_RECORDS:
                    return LARGE_QUERY_TIME, int(size), "too_large"
            except Exception as e:     # noqa: BLE001
                logging.info(f"count query failed: {e}")
                return OUT_OF_TIME_QUERY_TIME, 0, "error"
        self.pg.run_query(f'DROP TABLE IF EXISTS "{table}"')
        try:
            t, rows = self._timed(self.nj.run_query_stream, cypher, self.pg, max_records=MAX_RECORDS,
                                  table_name=table)
        except Exception as e:         # noqa: BLE001  (DataTooLargeError etc.)
            logging.info(f"graph query failed: {e}")
            return LARGE_QUERY_TIME, 0, "error"
        if rows is None:               # run_query_stream logs the exception and returns None
            return LARGE_QUERY_TIME, 0, "error"
        return t, rows, "ok"

    def run_plan(self, plan: SegmentPlan, output: str, last: bool, ra_table: str = None) -> dict:
        tm = {"status": "ok"}
        cypher, labels = plan.cypher, []
        if not self.mover:
            # per-plan movement under private labels (load now, delete after the plan)
            cypher, moves = relabel(plan.cypher, plan.move_base + plan.move_seg, "P_")
            move_base, move_seg = moves[:len(plan.move_base)], moves[len(plan.move_base):]
            labels = [l for _, l, _ in moves]
        try:
            try:
                if self.mover:
                    # movement executed/measured once and reused; its time still enters the composition
                    tm["pre_base"] = 0.0
                    for table, label, cols in plan.move_base:
                        self.mover.ensure_persistent(table, label, cols)
                        tm["pre_base"] += self.mover.move_time(table, cols)
                    tm["move_seg"] = sum(self.mover.seg_time(t, l, c) for t, l, c in plan.move_seg)
                    tm["movement_reused"] = True
                else:
                    tm["pre_base"], _ = self._timed(self.ex.run_table_movement_query, move_base)
                    tm["move_seg"], _ = self._timed(self.ex.run_table_movement_query, move_seg)
            except Exception as e:     # noqa: BLE001
                tm.update(status="error", error=f"table movement: {e}")
                return tm
            tm["graph"], tm["graph_rows"], st = self.run_graph(cypher, "neo4j")
            if st != "ok":
                tm.update(status=st, timeout=st in ("timeout", "too_large"))
                if st == "error":
                    tm["error"] = "graph query"
                return tm
            if tm["graph_rows"] == 0:
                # empty graph result -> empty query result; the precheck removes such queries
                tm.update(sql=0.0, sql_rows=0, status="empty", checksum=[0, 0])
                return tm
            target = ra_table if plan.split else (None if last else output)
            if target:
                self.pg.run_query(f'DROP TABLE IF EXISTS "{target}"')
                tm["sql"], _ = self._timed(self.pg.run_query, f'CREATE TABLE "{target}" AS\n{plan.sql}')
                if not self._exists(target):
                    tm.update(status="error", error="sql")
                    return tm
                tm["sql_rows"] = self.pg.run_query_return_result(f'select count(*) from "{target}"')[0][0]
                if self.checksum:
                    tm["checksum"] = self.pg_checksum(target)
            else:
                tm["sql"], res = self._timed(self.pg.run_query_return_result, plan.sql)
                if res is None:
                    tm.update(status="error", error="sql")
                    return tm
                tm["sql_rows"] = len(res)
                if self.checksum:
                    tm["checksum"] = py_checksum(res)
                if self.keep_result:
                    self.last_result = res
        finally:
            if labels:
                self.ex.clean_data(set(labels))
        return tm

    def run_rib(self, sql: str, output: str, last: bool) -> dict:
        ra = re.search(r"from (\w+) ra", sql).group(1)
        if not self._exists(ra):
            return {"rib": 0.0, "rows": 0, "status": "error", "error": f"{ra} missing"}
        if last:
            t, res = self._timed(self.pg.run_query_return_result, sql)
            if res is None:
                return {"rib": t, "rows": 0, "status": "error", "error": "sql"}
            if self.keep_result:
                self.last_result = res
            return {"rib": t, "rows": len(res), "status": "ok", "checksum": py_checksum(res) if self.checksum else None}
        self.pg.run_query(f'DROP TABLE IF EXISTS "{output}"')
        t, _ = self._timed(self.pg.run_query, f'CREATE TABLE "{output}" AS\n{sql}')
        if not self._exists(output):
            return {"rib": t, "rows": 0, "status": "error", "error": "sql"}
        return {"rib": t, "rows": self.pg.run_query_return_result(f'select count(*) from "{output}"')[0][0],
                "status": "ok", "checksum": self.pg_checksum(output) if self.checksum else None}


# ---------------------------------------------------------------------------
# Offline composition
# ---------------------------------------------------------------------------
def _cap(t):
    return min(t, OUT_OF_TIME_QUERY_TIME)


def segment_cost(p: dict) -> dict:
    t = p["timings"]
    if t.get("status") == "error":
        return {"error": True}
    if t.get("timeout"):
        return {"timeout": True}
    return {"pre_base": t.get("pre_base", 0), "move_seg": t.get("move_seg", 0),
            "graph": t.get("graph", 0), "sql": t.get("sql", 0)}


def compose(stage_plans: list, rib: list) -> list:
    """stage_plans[i]: list of plan dicts (with timings) for segment i; rib[i]: R_ib time (i>0)."""
    out = []
    for combo in itertools.product(*[range(len(s)) for s in stage_plans]):
        end, timeout, error = 0.0, False, False
        for i, pi in enumerate(combo):
            p = stage_plans[i][pi]
            c = segment_cost(p)
            if c.get("error"):
                error = True
                break
            if c.get("timeout"):
                timeout = True
                break
            if i == 0:
                end = c["pre_base"] + c["graph"] + c["sql"]
            elif p["seg_moved"]:
                end = max(end, c["pre_base"]) + c["move_seg"] + c["graph"] + c["sql"]
            else:
                end = max(end, c["pre_base"] + c["graph"] + c["sql"]) + rib[i]
        if error:
            out.append({"combo": list(combo), "latency": None, "timeout": False, "error": True})
        else:
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
            # real flow: every branch loads its own copies under branch-specific labels (no sharing)
            cypher, moves = relabel(plan.cypher, plan.move_base + plan.move_seg, f"V{i + 1}_")
            ex.ex.run_table_movement_query(moves[:len(plan.move_base)])
            if i > 0 and plan.seg_moved:
                done[i - 1].wait()
                ex.ex.run_table_movement_query(moves[len(plan.move_base):])
            ex.run_graph(cypher, nj_table)
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
        ex.ex.clean_data({f"V{i + 1}_{l}" for _, l, _ in p["move_base"] + p["move_seg"]})
        ex.pg.run_query(f'DROP TABLE IF EXISTS "neo4j_s{i + 1}"')
        ex.pg.disconnect()
    if errors:
        raise errors[0]
    return elapsed


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------
def build_rewriters(mq: dict, keep_params: bool):
    stages = [Stage(**s) for s in mq["stages"]]
    k = len(stages)
    parsed = [parse_stage(st, i + 1) for i, st in enumerate(stages)]
    return stages, [SegmentRewriter(ps, i == k - 1, keep_params) for i, ps in enumerate(parsed)]


def precheck_query(mq: dict, seg_ex: SegmentExecutor, keep_params: bool, max_seconds: float = None) -> dict:
    """Cheap validity check before the full collection (one execution per segment).

    1. EXPLAIN every candidate plan's Cypher (nothing is executed). A failure on the canonical plan means
       the query is wrong; a failure on another plan means a rewrite bug.
    2. Execute the canonical plan (nothing moved) segment by segment, plus R_ib.
       Fails on: error, timeout, empty graph result, empty seg{i} or final result, too slow.
    """
    stages, rws = build_rewriters(mq, keep_params)
    rep = {"ok": False, "reason": "", "kind": "", "segments": [], "seconds": 0.0}
    for i, rw in enumerate(rws):
        for j, p in enumerate(rw.plans()):
            try:
                seg_ex.nj.explain_query_plan(p.cypher)
            except Exception as e:     # noqa: BLE001
                rep.update(reason=f"segment {i + 1} plan {p.moved}: EXPLAIN failed: {e}",
                           kind="query" if j == 0 else "rewrite")
                return rep
    k = len(stages)
    for i, rw in enumerate(rws):
        last = i == k - 1
        p0 = rw.rewrite([])
        tm = seg_ex.run_plan(p0, stages[i].output, last, ra_table=f"r{i + 1}a")
        seg = {"segment": i + 1, "graph_rows": tm.get("graph_rows"), "status": tm["status"]}
        rep["seconds"] += sum(tm.get(x, 0) for x in ("pre_base", "move_seg", "graph", "sql"))
        if tm["status"] != "ok":
            rep["segments"].append(seg)
            rep.update(reason=f"segment {i + 1}: {tm['status']} {tm.get('error', '')}".strip(), kind="query")
            return rep
        rows = tm["sql_rows"]
        if p0.split:
            rb = seg_ex.run_rib(rw.rib_sql(f"r{i + 1}a"), stages[i].output, last)
            rep["seconds"] += rb["rib"]
            if rb["status"] != "ok":
                rep["segments"].append(seg)
                rep.update(reason=f"segment {i + 1} R_ib: {rb.get('error')}", kind="query")
                return rep
            rows = rb["rows"]
        seg["output_rows"] = rows
        rep["segments"].append(seg)
        if rows == 0:
            rep.update(reason=f"segment {i + 1}: empty {'result' if last else stages[i].output}", kind="query")
            return rep
    if max_seconds and rep["seconds"] > max_seconds:
        rep.update(reason=f"canonical plan too slow ({rep['seconds']:.1f}s)", kind="query")
        return rep
    rep["ok"] = True
    return rep


def collect_query(mq: dict, seg_ex: SegmentExecutor, keep_params: bool, repeat: int, dry_run: bool):
    t_start = time.time()
    try:
        rec, rws = _collect_query(mq, seg_ex, keep_params, repeat, dry_run)
    finally:
        if seg_ex is not None and seg_ex.mover:
            seg_ex.mover.end_query()          # seg{i} nodes live for one query only
    rec["collection_seconds"] = time.time() - t_start
    return rec, rws


def _collect_query(mq: dict, seg_ex: SegmentExecutor, keep_params: bool, repeat: int, dry_run: bool):
    stages, rewriters = build_rewriters(mq, keep_params)
    k = len(stages)
    plans_by_stage, rib_time, rib_rec, raw_plans, consistency = [], [0.0] * k, {}, [], []
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
            # every plan of a segment must produce the same output (seg{i} / final result; R_ia separately)
            ok = [r for r in recs if r["timings"].get("status") == "ok"]
            full = {tuple(r["timings"]["checksum"]) for r in ok if not r["split"] and r["timings"].get("checksum")}
            if rib_rec.get(i + 1, {}).get("checksum"):
                full.add(tuple(rib_rec[i + 1]["checksum"]))
            ra = {tuple(r["timings"]["checksum"]) for r in ok if r["split"] and r["timings"].get("checksum")}
            errors = [{"moved": r["moved"], "error": r["timings"].get("error")} for r in recs
                      if r["timings"].get("status") == "error"]
            consistency.append({"segment": i + 1, "distinct_outputs": len(full), "distinct_r_a": len(ra),
                                "plan_errors": errors})
            try:
                raw_plans.append(seg_ex.nj.explain_query_plan(stages[i].cypher))
            except Exception as e:     # noqa: BLE001
                raw_plans.append(None)
                logging.info(f"explain failed: {e}")
        plans_by_stage.append(recs)
    composite = [] if dry_run else compose(plans_by_stage, rib_time)
    n_exec = sum(len(s) for s in plans_by_stage) + len(rib_rec)
    usable = all(c["distinct_outputs"] <= 1 and c["distinct_r_a"] <= 1 and not c["plan_errors"]
                 for c in consistency)
    return {"original": mq["original"], "k": k, "segments": plans_by_stage, "rib": rib_rec,
            "neo4j_raw_plans": raw_plans, "composite": composite, "executions": n_exec,
            "consistency": consistency, "usable_for_training": usable if not dry_run else None}, rewriters


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
    ap.add_argument("--precheck-only", action="store_true",
                    help="only run the cheap precheck; write the passing queries to precheck_passed.jsonl")
    ap.add_argument("--no-precheck", action="store_true", help="skip the precheck before collection")
    ap.add_argument("--no-movement-reuse", action="store_true",
                    help="load/delete moved tables for every plan (baseline for the collection-time comparison)")
    ap.add_argument("--movement-repeat", type=int, default=3, help="timed loads per (table, columns); median")
    ap.add_argument("--reset-persistent", action="store_true",
                    help="delete the persistent base-table nodes first (e.g. after switching T1/T2 or a Neo4j reload)")
    ap.add_argument("--drop-persistent-at-end", action="store_true")
    ap.add_argument("--max-precheck-seconds", type=float, default=None,
                    help="drop queries whose canonical plan takes longer than this")
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

        def make_executor(timeout_count=True, mover=None):
            nj = Neo4jUtil(f"bolt://{args.nj_uri}", args.nj_user, args.nj_pw, args.nj_db)
            pg = PostgresUtil(args.pg_db, args.pg_user, args.pg_pw, args.pg_host)
            pg.connect()
            return SegmentExecutor(RunPlan(pg, nj), timeout_count, mover=mover)
        seg_ex = make_executor()
        if not args.no_movement_reuse:
            seg_ex.mover = MovementManager(seg_ex.ex, os.path.join(args.result_dir, "movement_cache.json"),
                                           db_key=f"{args.nj_uri}/{args.nj_db}|{args.pg_host}/{args.pg_db}",
                                           repeat=args.movement_repeat)
            if args.reset_persistent:
                seg_ex.mover.drop_persistent()

    queries = [json.loads(l) for l in open(args.queries)]
    out_path = os.path.join(args.result_dir, "multiseg_plans_with_runtime.jsonl")
    pre_path = os.path.join(args.result_dir, "precheck_report.jsonl")
    passed_path = os.path.join(args.result_dir, "precheck_passed.jsonl")
    summary = {"queries": len(queries), "skipped_params": 0, "precheck_failed_query": 0,
               "precheck_failed_rewrite": 0, "collected": 0, "inconsistent_or_plan_errors": 0,
               "collection_seconds": 0.0}
    to_validate = []
    with open(out_path, "w") as out, open(pre_path, "w") as pre, open(passed_path, "w") as passed:
        for qi, mq in enumerate(queries):
            logging.info(f"============= query {qi} =============")
            if any("$" in st["cypher"] for st in mq["stages"]):
                # a predicate on a graph-resident property (id) is left in the Cypher and needs a value
                print(f"[skip] query {qi}: Cypher still contains $params; instantiate it first")
                summary["skipped_params"] += 1
                continue
            if any("$" in st[f] for st in mq["stages"] for f in ("post_where", "order_by", "limit")):
                # LIMIT / HAVING-style thresholds define the query and cannot be dropped like $param filters
                print(f"[skip] query {qi}: boundary LIMIT/threshold still has $params; instantiate it first")
                summary["skipped_params"] += 1
                continue
            if not args.dry_run and not args.no_precheck:
                rep = precheck_query(mq, seg_ex, args.keep_params, args.max_precheck_seconds)
                rep["query_id"] = qi
                pre.write(json.dumps(rep) + "\n")
                pre.flush()
                if not rep["ok"]:
                    summary[f"precheck_failed_{rep['kind']}"] += 1
                    print(f"[precheck] query {qi} dropped ({rep['kind']}): {rep['reason']}")
                    continue
                passed.write(json.dumps(mq) + "\n")
                passed.flush()
                if args.precheck_only:
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
            else:
                summary["collected"] += 1
                if not rec["usable_for_training"]:
                    summary["inconsistent_or_plan_errors"] += 1
                    print(f"[warn] query {qi}: plan outputs differ or plans failed: {rec['consistency']}")
            if args.validate and not args.dry_run and rec["composite"]:
                to_validate.append((qi, mq, rec))
            out.write(json.dumps(rec) + "\n")
            out.flush()
            summary["collection_seconds"] += rec.get("collection_seconds", 0)

    if to_validate:
        # real flow on a clean graph: persistent base-table nodes are removed first, every branch loads
        # and deletes its own moved tables, independent branches run in parallel threads
        if seg_ex.mover:
            seg_ex.mover.drop_persistent()
        val_path = os.path.join(args.result_dir, "validation.jsonl")
        rel_err = []
        with open(val_path, "w") as vf:
            for qi, mq, rec in to_validate:
                _, rws = build_rewriters(mq, args.keep_params)
                outputs = [s["output"] for s in mq["stages"]]
                cands = [c for c in rec["composite"] if not c["timeout"] and not c.get("error")]
                for c in random.sample(cands, min(args.validate, len(cands))):
                    real = run_composite(make_executor, rws, rec["segments"], c["combo"], outputs)
                    vf.write(json.dumps({"query_id": qi, "combo": c["combo"], "composed": c["latency"],
                                         "real": real}) + "\n")
                    rel_err.append(abs(c["latency"] - real) / max(real, 1e-9))
        rel_err.sort()
        summary["validation_plans"] = len(rel_err)
        summary["validation_median_rel_error"] = rel_err[len(rel_err) // 2] if rel_err else None
    elif seg_ex is not None and seg_ex.mover and args.drop_persistent_at_end:
        seg_ex.mover.drop_persistent()
    if seg_ex is not None and seg_ex.mover:
        summary["movement_cache_hits"], summary["movement_cache_misses"] = seg_ex.mover.hits, seg_ex.mover.misses
    print(json.dumps(summary, indent=1))
    print(f"wrote {out_path}" + ("" if args.dry_run else f", {pre_path}, {passed_path}"))


if __name__ == "__main__":
    main()
