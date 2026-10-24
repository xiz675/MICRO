"""
XDB baseline for the multi-segment workload: run the all-SQL equivalent of every query in one PostgreSQL that
holds the graph as edge/filter tables (db1) and reaches the property tables (r_*, db2: postgres = T1, t2 = T2)
through postgres_fdw, as set up in README.md.

The SQL is generated from the same decomposed queries the MICRO collection used (precheck_passed.jsonl of a
configuration, with its calibrated thresholds): each graph stage becomes a CTE over the edge tables (bounded
KNOWS*1..2 expanded with UNION ALL), $param filters are dropped (CM-LDBC convention, as for the ICDE XDB queries).

    python run_multiseg_xdb.py /result/sf1-t1/precheck/precheck_passed.jsonl /result/sf1-t1/xdb/ \
        --collected /result/sf1-t1/run/multiseg_plans_with_runtime.jsonl \
        --pg-host lero-postgres2-sf1 --pg-db postgres --pg-pw xw --timeout 1800

Writes <out>/xdb_queries.sql (one statement per query, `-- query <id>` headers) and <out>/xdb_results.jsonl:
    {"query_id", "status": ok|timeout|error, "seconds", "rows", "micro_rows", "rows_match", "error"}
query_id is the line index in the queries file, the same id as in multiseg_plans_with_runtime.jsonl.
--collected restricts the run to the collected queries and compares the row count with MICRO's final result
(a mismatch points at a translation problem; a timeout is reported with seconds = the timeout).
"""
import argparse
import json
import os
import statistics
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path[:0] = [os.path.join(HERE, "..", "benchmark"), os.path.join(HERE, "..", "benchmark", "ldbc-workload-generation")]
from multiseg_query_rewrite import Stage, multiseg_to_sql   # noqa: E402


class _MQ:
    def __init__(self, mq):
        self.stages = [Stage(**s) for s in mq["stages"]]
        self.k = len(self.stages)


def micro_final_rows(rec: dict):
    """rows of the final result in the MICRO collection (shared R_kb, or a plan that does not split)"""
    k = rec["k"]
    rib = rec.get("rib", {}).get(str(k)) or {}
    if rib.get("rows") is not None:
        return rib["rows"]
    for p in rec["segments"][k - 1]:
        t = p["timings"]
        if not p.get("split") and t.get("status") == "ok" and t.get("sql_rows") is not None:
            return t["sql_rows"]
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("queries", help="precheck_passed.jsonl of the configuration (input of the MICRO collection)")
    ap.add_argument("out_dir")
    ap.add_argument("--collected", help="multiseg_plans_with_runtime.jsonl: run only these queries, compare rows")
    ap.add_argument("--only-usable", action="store_true", help="with --collected: skip usable_for_training=false")
    ap.add_argument("--query", type=int, nargs="*", default=None, help="only these query ids")
    ap.add_argument("--timeout", type=float, default=1800, help="statement timeout in seconds")
    ap.add_argument("--repeat", type=int, default=1, help="runs per query, median time reported")
    ap.add_argument("--dry-run", action="store_true", help="only write xdb_queries.sql")
    ap.add_argument("--search-path", default=None,
                    help='e.g. "t1, public": schema with the foreign r_* tables of the configuration first')
    ap.add_argument("--pg-host", default="localhost")
    ap.add_argument("--pg-port", type=int, default=5432)
    ap.add_argument("--pg-db", default="postgres")
    ap.add_argument("--pg-user", default="postgres")
    ap.add_argument("--pg-pw", default=os.environ.get("PG_PASSWORD", "postgres"))
    args = ap.parse_args()
    os.makedirs(args.out_dir, exist_ok=True)

    queries = [json.loads(l) for l in open(args.queries) if l.strip()]
    ids = list(range(len(queries))) if args.query is None else list(args.query)
    micro = {}
    if args.collected:
        for l in open(args.collected):
            rec = json.loads(l)
            if args.only_usable and not rec.get("usable_for_training"):
                continue
            micro[rec["query_id"]] = micro_final_rows(rec)
        ids = [i for i in ids if i in micro]

    sqls = {}
    with open(os.path.join(args.out_dir, "xdb_queries.sql"), "w") as f:
        for i in ids:
            sql = multiseg_to_sql(_MQ(queries[i]))
            sqls[i] = sql
            f.write(f"-- query {i}\n{sql if sql else '-- TODO: not translatable'};\n\n")
    print(f"{len(ids)} queries, {sum(1 for s in sqls.values() if s)} translated -> {args.out_dir}/xdb_queries.sql")
    if args.dry_run:
        return

    import psycopg2
    con = psycopg2.connect(host=args.pg_host, port=args.pg_port, dbname=args.pg_db, user=args.pg_user,
                           password=args.pg_pw)
    con.autocommit = True
    cur = con.cursor()
    cur.execute(f"SET statement_timeout = {int(args.timeout * 1000)}")
    if args.search_path:
        cur.execute(f"SET search_path TO {args.search_path}")
    summary = {"ok": 0, "timeout": 0, "error": 0, "untranslated": 0, "rows_mismatch": 0}
    with open(os.path.join(args.out_dir, "xdb_results.jsonl"), "w") as out:
        for i in ids:
            rec = {"query_id": i, "micro_rows": micro.get(i)}
            if not sqls[i]:
                rec.update(status="untranslated")
                summary["untranslated"] += 1
            else:
                times, rows, status, err = [], None, "ok", None
                for _ in range(args.repeat):
                    t = time.time()
                    try:
                        cur.execute(sqls[i])
                        rows = len(cur.fetchall())
                        times.append(time.time() - t)
                    except psycopg2.errors.QueryCanceled:
                        status, times = "timeout", [args.timeout]
                        break
                    except Exception as e:      # noqa: BLE001
                        status, err, times = "error", str(e).splitlines()[0][:300], [time.time() - t]
                        break
                rec.update(status=status, seconds=statistics.median(times), rows=rows, error=err)
                summary[status] += 1
                if status == "ok" and rec["micro_rows"] is not None:
                    rec["rows_match"] = rows == rec["micro_rows"]
                    summary["rows_mismatch"] += not rec["rows_match"]
            out.write(json.dumps(rec) + "\n")
            out.flush()
            print(f"query {i}: {rec['status']} {rec.get('seconds', 0):.2f}s rows={rec.get('rows')} "
                  f"micro={rec['micro_rows']}" + (f" {rec.get('error')}" if rec.get("error") else ""))
    print(json.dumps(summary, indent=1))


if __name__ == "__main__":
    main()
