"""
Pilot for multi-segment CMGRJ queries (TKDE extension).

For every query, enumerate the 2^(k-1) combinations of the per-boundary decision
    unbound : run G_i independently in Neo4j, join with seg{i-1} in PostgreSQL
    bound   : push seg{i-1}'s carried ids back into Neo4j and start G_i from them
and record per-stage time and intermediate sizes. The goal is to confirm the trade-off exists
(neither choice dominates) before generating the full workload.

Input: a file of *instantiated* virtual-graph queries (no $params left), separated by ';'.

    python multiseg_pilot.py queries.cypher out.jsonl --neo4j-uri bolt://... --pg-db ...
    python multiseg_pilot.py queries.cypher out.jsonl --dry-run      # print plans only
"""
import argparse
import itertools
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
BENCH = os.path.join(HERE, "..", "benchmark")
sys.path[:0] = [BENCH, os.path.join(BENCH, "ldbc-workload-generation")]
from multiseg_query_rewrite import decompose_multiseg  # noqa: E402


def inline_binding(bound_cypher: str, prev: str, rows: list, cols: list) -> str:
    """Replace `UNWIND $seg{i} AS b` with an inline list of maps (apoc.runTimeboxed takes no params)."""
    items = ", ".join("{" + ", ".join(f"{c}: {int(r[j])}" for j, c in enumerate(cols)) + "}" for r in rows)
    return bound_cypher.replace(f"UNWIND ${prev} AS b", f"UNWIND [{items}] AS b", 1)


def plans_for(mq):
    return list(itertools.product([False, True], repeat=mq.k - 1))


def run_plan(mq, plan, neo4j, pg, timeout):
    rec = {"plan": ["bound" if b else "unbound" for b in plan], "stages": [], "ok": True}
    t_total = time.time()
    for i, st in enumerate(mq.stages):
        s = {"stage": i + 1}
        bound = i > 0 and plan[i - 1]
        cypher = st.cypher
        if bound:
            prev = f"seg{i}"
            cols = [f"{v}id" for v in st.carried_in]
            t = time.time()
            rows = pg.run_query_return_result(f"select {', '.join(cols)} from {prev}") or []
            s["pushback_rows"], s["pushback_fetch_s"] = len(rows), time.time() - t
            if not rows:
                rec["stages"].append(s)
                rec["empty"] = True
                break
            cypher = inline_binding(st.bound_cypher, prev, rows, cols)
        t = time.time()
        df = neo4j.run_query_return_df(cypher, timeout_seconds=timeout)
        s["graph_s"] = time.time() - t
        s["graph_rows"] = 0 if df is None else len(df)
        if df is None or len(df) == 0:
            rec["stages"].append(s)
            rec["empty"] = True
            break
        t = time.time()
        pg.insert_neo4j_results(df, "neo4j")
        s["transfer_s"] = time.time() - t
        t = time.time()
        if i < mq.k - 1:
            pg.run_query(f"DROP TABLE IF EXISTS {st.output}")
            pg.run_query(f"CREATE TABLE {st.output} AS\n{st.sql}")
            s["seg_rows"] = pg.run_query_return_result(f"select count(*) from {st.output}")[0][0]
        else:
            res = pg.run_query_return_result(st.sql)
            s["result_rows"] = 0 if res is None else len(res)
        s["sql_s"] = time.time() - t
        rec["stages"].append(s)
    rec["total_s"] = time.time() - t_total
    return rec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("queries")
    ap.add_argument("out")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--neo4j-uri", default="bolt://localhost:7687")
    ap.add_argument("--neo4j-user", default="neo4j")
    ap.add_argument("--neo4j-password", default=os.environ.get("NEO4J_PASSWORD", ""))
    ap.add_argument("--neo4j-db", default="neo4j")
    ap.add_argument("--pg-db", default="ldbc")
    ap.add_argument("--pg-user", default="postgres")
    ap.add_argument("--pg-password", default=os.environ.get("PG_PASSWORD", ""))
    ap.add_argument("--pg-host", default="localhost")
    ap.add_argument("--timeout", type=int, default=600)
    ap.add_argument("--repeat", type=int, default=1)
    args = ap.parse_args()

    queries = [q.strip() for q in open(args.queries).read().split(";") if q.strip()]
    neo4j = pg = None
    if not args.dry_run:
        from utils.neo4j_utils import Neo4jUtil
        from utils.pg_utils import PostgresUtil
        neo4j = Neo4jUtil(args.neo4j_uri, args.neo4j_user, args.neo4j_password, args.neo4j_db)
        pg = PostgresUtil(args.pg_db, args.pg_user, args.pg_password, args.pg_host)
        pg.connect()

    with open(args.out, "w") as out:
        for qi, q in enumerate(queries):
            if "$" in q:
                print(f"[skip] query {qi} still has $params")
                continue
            # keep the virtual-graph labels as written; subset labels are a workload-generation choice
            mq = decompose_multiseg(q, modify_labels=False)
            for plan in plans_for(mq):
                if args.dry_run:
                    print(f"=== query {qi} plan {['bound' if b else 'unbound' for b in plan]}")
                    for i, st in enumerate(mq.stages):
                        use_bound = i > 0 and plan[i - 1]
                        print(f"-- G{i + 1}:", (st.bound_cypher if use_bound else st.cypher).replace("\n", " "))
                        print(f"-- SQL{i + 1} -> {st.output}:", st.sql.replace("\n", " "))
                    continue
                for r in range(args.repeat):
                    rec = run_plan(mq, plan, neo4j, pg, args.timeout)
                    rec.update(query_id=qi, repeat=r, k=mq.k)
                    out.write(json.dumps(rec) + "\n")
                    out.flush()
                    print(qi, rec["plan"], f"{rec['total_s']:.2f}s")
    if pg:
        pg.disconnect()
    if neo4j:
        neo4j.close()


if __name__ == "__main__":
    main()
