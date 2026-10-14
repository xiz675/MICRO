"""
Explain why a query's canonical plan is empty: runs segment by segment and reports the row count after each step.

For every segment:
  graph rows        rows returned by the Cypher (written to table dbg_neo4j)
  join <table>      graph rows whose id exists in that property table (each join on its own)
  all joins         rows after joining every property table (and seg{i-1})
  output            rows of the segment's SQL (after GROUP BY / HAVING / LIMIT)
  aggregate         min / median / max of the boundary aggregate before the HAVING threshold

    python multiseg_debug.py ../benchmark/ldbc-workload-generation/workload/multiseg_queries.jsonl --query 0 2 4 \
        --nj-uri lero-neo4j-sf1:7687 --pg-host lero-postgres-sf1 --pg-db postgres --pg-pw xw
"""
import argparse
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import multiseg_collect as mc                                     # noqa: E402


def q1(pg, sql):
    r = pg.run_query_return_result(sql)
    return r[0][0] if r else None


def debug_query(qi, mq, nj, pg, max_records):
    _, rws = mc.build_rewriters(mq, keep_params=False)
    print(f"################ query {qi} ################")
    print(mq.get("original", "").strip())
    for i, rw in enumerate(rws):
        p = rw.rewrite([])
        out = mq["stages"][i]["output"]
        print(f"\n=== segment {i + 1} ===")
        print(p.cypher)
        pg.run_query("DROP TABLE IF EXISTS dbg_neo4j")
        try:
            n = nj.run_query_stream(p.cypher, pg, max_records=max_records, table_name="dbg_neo4j")
        except Exception as e:                                     # noqa: BLE001
            print(f"  graph query failed: {type(e).__name__}: {str(e)[:300]}")
            return
        print(f"  graph rows          {n:>12,}")
        if not n:
            print("  -> the Cypher itself returns nothing (labels / edges / subset labels)")
            return
        for m in rw.ps.joins:
            c = q1(pg, f"SELECT count(*) FROM dbg_neo4j n JOIN {m.table} t ON n.{m.neo4j_col} = t.{m.table_col}")
            total = q1(pg, f"SELECT count(*) FROM {m.table}")
            print(f"  join {m.table:12s}   {c:>12,}   (table has {total:,} rows)")
        sql = re.sub(r"\bneo4j\b", "dbg_neo4j", p.sql)
        inner = re.search(r"(?is)^select \* from \((.*)\)\s*b1\s*where", sql)
        core = inner.group(1) if inner else sql
        frm = re.search(r"(?is)\bfrom\b(.*?)(\bgroup by\b|$)", core).group(1)
        print(f"  all joins           {q1(pg, f'SELECT count(*) FROM {frm}'):>12,}")
        if inner:
            agg = re.search(r"(?i)select\s+(.*?)\s+AS\s+(\w+)", core)
            alias = re.search(r"(?is)\)\s*b1\s*where\s+(\w+)", sql)
            if alias:
                r = pg.run_query_return_result(
                    f"SELECT count(*), min({alias.group(1)}), percentile_disc(0.5) WITHIN GROUP "
                    f"(ORDER BY {alias.group(1)}), max({alias.group(1)}) FROM ({core}) g")
                if r:
                    print(f"  groups {r[0][0]:,}; {alias.group(1)} min {r[0][1]}, median {r[0][2]}, max {r[0][3]}")
            print(f"  boundary            {sql[inner.end():].strip()}")
        if p.split:
            pg.run_query(f"DROP TABLE IF EXISTS dbg_r{i + 1}a")
            pg.run_query(f"CREATE TABLE dbg_r{i + 1}a AS {sql}")
            rib = rw.rib_sql(f"dbg_r{i + 1}a")
            rows = q1(pg, f"SELECT count(*) FROM ({rib}) x")
        else:
            rows = q1(pg, f"SELECT count(*) FROM ({sql}) x")
        print(f"  output              {rows:>12,}")
        if not rows:
            print("  -> empty after SQL: see which join or the boundary threshold removes everything")
            return
        # keep the output as seg{i+1} for the next segment
        pg.run_query(f"DROP TABLE IF EXISTS {out}")
        pg.run_query(f"CREATE TABLE {out} AS {rib if p.split else sql}")
    print()


def _sql_diff(pg, a, b):
    try:
        x = q1(pg, f"select count(*) from (select * from {a} except all select * from {b}) t")
        y = q1(pg, f"select count(*) from (select * from {b} except all select * from {a}) t")
    except Exception as e:      # noqa: BLE001
        return f"cannot compare: {e}"
    out = f"rows only in {a}: {x}, only in {b}: {y}"
    if x or y:
        out += f"\n        e.g. only in {a}: " + str(pg.run_query_return_result(
            f"(select * from {a} except all select * from {b}) limit 3"))
        out += f"\n        e.g. only in {b}: " + str(pg.run_query_return_result(
            f"(select * from {b} except all select * from {a}) limit 3"))
    return out


def compare_segment(qi, mq, seg, nj, pg):
    """run every plan of one segment (per-plan movement, as in the ICDE runs) and show how each plan's output
    differs from the canonical plan's: row counts, rows only in one of them, column types"""
    from collections import Counter
    from utils.run_plan_util import RunPlan
    stages, rws = mc.build_rewriters(mq, keep_params=False)
    i = seg - 1
    last = i == len(stages) - 1
    ex = mc.SegmentExecutor(RunPlan(pg, nj), timeout_count=True, keep_result=True)
    print(f"################ query {qi}, segment {seg} ################")
    for j in range(i):                       # previous segments: canonical plans, outputs kept as seg{j}
        p = rws[j].rewrite([])
        ex.run_plan(p, stages[j].output, False, ra_table=f"r{j + 1}a")
        if p.split:
            ex.run_rib(rws[j].rib_sql(f"r{j + 1}a"), stages[j].output, False)
    types = lambda t: pg.run_query_return_result(  # noqa: E731
        f"select column_name, data_type from information_schema.columns where table_name='{t}' order by ordinal_position")
    finals = {}
    for j, p in enumerate(rws[i].plans()):
        tm = ex.run_plan(p, stages[i].output, last, ra_table=f"r{i + 1}a")
        print(f"  plan {j}: moved={p.moved} split={p.split} status={tm['status']} {tm.get('error', '')} "
              f"graph_rows={tm.get('graph_rows')} sql_rows={tm.get('sql_rows')}")
        if tm["status"] != "ok":
            continue
        if p.split:                          # plan-specific part R_ia must be identical across split plans
            pg.run_query(f"DROP TABLE IF EXISTS cmp_ra{j}")
            pg.run_query(f'CREATE TABLE cmp_ra{j} AS SELECT * FROM "r{i + 1}a"')
            rb = ex.run_rib(rws[i].rib_sql(f"r{i + 1}a"), stages[i].output, last)
            res = ex.last_result if last else None
        else:
            res = ex.last_result if last else None
        if last:
            finals[j] = Counter(map(str, res or []))
        else:
            pg.run_query(f"DROP TABLE IF EXISTS cmp_p{j}")
            pg.run_query(f'CREATE TABLE cmp_p{j} AS SELECT * FROM "{stages[i].output}"')
    plans = rws[i].plans()
    split_ids = [j for j, p in enumerate(plans) if p.split and q1(pg, f"select to_regclass('cmp_ra{j}') is not null")]
    if split_ids:
        r0 = split_ids[0]
        print(f"\n  R_{seg}a columns (plan {r0}): {types(f'cmp_ra{r0}')}")
        for j in split_ids[1:]:
            print(f"  R_{seg}a plan {j} {plans[j].moved} vs plan {r0}: {_sql_diff(pg, f'cmp_ra{j}', f'cmp_ra{r0}')}")
    if last:
        base = finals.get(0)
        print(f"\n  final result of plan 0: {sum(base.values()) if base is not None else None} rows")
        for j, c in finals.items():
            if j and base is not None and c != base:
                print(f"  final plan {j} {plans[j].moved}: {sum(c.values())} rows; "
                      f"only in plan 0: {list((base - c).elements())[:3]}; only in plan {j}: {list((c - base).elements())[:3]}")
    else:
        print(f"\n  output columns (plan 0): {types('cmp_p0')}")
        for j in range(1, len(plans)):
            if q1(pg, f"select to_regclass('cmp_p{j}') is not null"):
                print(f"  output plan {j} {plans[j].moved} vs plan 0: {_sql_diff(pg, f'cmp_p{j}', 'cmp_p0')}")
    print()


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("queries")
    ap.add_argument("--query", type=int, nargs="+", required=True)
    ap.add_argument("--compare-segment", type=int, default=None,
                    help="run every plan of this segment (1-based) and show how their outputs differ")
    ap.add_argument("--max-records", type=int, default=mc.MAX_RECORDS)
    ap.add_argument("--nj-uri", default="lero-neo4j-sf1:7687")
    ap.add_argument("--nj-db", default="neo4j")
    ap.add_argument("--nj-user", default="neo4j")
    ap.add_argument("--nj-pw", default=os.environ.get("NEO4J_PASSWORD", "neo4j"))
    ap.add_argument("--pg-host", default="lero-postgres-sf1")
    ap.add_argument("--pg-db", default="postgres")
    ap.add_argument("--pg-user", default="postgres")
    ap.add_argument("--pg-pw", default=os.environ.get("PG_PASSWORD", "postgres"))
    args = ap.parse_args()
    from utils.neo4j_utils import Neo4jUtil
    from utils.pg_utils import PostgresUtil
    nj = Neo4jUtil(f"bolt://{args.nj_uri}", args.nj_user, args.nj_pw, args.nj_db)
    pg = PostgresUtil(args.pg_db, args.pg_user, args.pg_pw, args.pg_host)
    pg.connect()
    queries = [json.loads(l) for l in open(args.queries)]
    for qi in args.query:
        if args.compare_segment:
            compare_segment(qi, queries[qi], args.compare_segment, nj, pg)
        else:
            debug_query(qi, queries[qi], nj, pg, args.max_records)


if __name__ == "__main__":
    main()
