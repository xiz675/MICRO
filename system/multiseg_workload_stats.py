"""
Per-segment statistics of a multi-segment workload (output of multiseg_query_rewrite.py), no database needed.

For every segment i it reports, over all queries:
  * Cypher path length: number of relationship hops in G_i; a variable-length pattern (KNOWS*1..2) is
    counted as its maximum hops and also reported separately (the ICDE stats util caps it at 100)
  * tables joined: vertex-table joins in SQL_i (property tables joined with the Neo4j result; the movable
    relations of the plan space), and distinct table types among them
  * movable relations = tables joined + 1 for seg{i-1} (i > 1) and sub-plans = 2^movable
plus the boundary type and the plan-space size per query (prod_i 2^movable_i).

    python multiseg_workload_stats.py ../benchmark/ldbc-workload-generation/workload/multiseg_queries.jsonl
    python multiseg_workload_stats.py <queries.jsonl> --csv stats.csv      # one row per (query, segment)
"""
import argparse
import csv
import json
import re
import statistics
from collections import Counter

import multiseg_collect as mc          # parse_stage: same parsing the collector uses for the plan space
from multiseg_query_rewrite import Stage

EDGE_RE = re.compile(r"-\[[^\]]*\]-")
VARLEN_RE = re.compile(r"\*\s*(\d*)\s*(?:\.\.\s*(\d+))?")


def path_hops(cypher: str) -> tuple:
    """(hops, has_varlength) over the MATCH part of a segment's graph query"""
    match = re.split(r"(?i)\breturn\b", cypher)[0]
    hops, varlen = 0, False
    for edge in EDGE_RE.findall(match):
        m = VARLEN_RE.search(edge)
        if m:
            varlen = True
            hops += int(m.group(2) or m.group(1) or 1)
        else:
            hops += 1
    return hops, varlen


def boundary_type(stage: Stage) -> str:
    if stage.limit:
        return "topk"
    if stage.post_where:
        return "having"
    return "-"


def segment_rows(mq: dict) -> list:
    rows = []
    for i, s in enumerate(mq["stages"]):
        st = Stage(**s)
        ps = mc.parse_stage(st, i + 1)
        hops, varlen = path_hops(st.cypher)
        tables = [j for j in ps.joins if not j.is_seg]      # seg{i-1} is counted separately
        joins = len(tables)
        movable = len(ps.joins)                             # = joins + 1 for seg{i-1} when i > 1
        rows.append({"query_id": mq.get("query_id"), "segment": i + 1, "path_hops": hops, "varlength": varlen,
                     "tables_joined": joins, "table_types": len({j.table for j in tables}),
                     "tables": " ".join(sorted(j.table for j in tables)),
                     "movable": movable, "subplans": 2 ** movable,
                     "boundary": boundary_type(st) if i < len(mq["stages"]) - 1 else "final"})
    return rows


def summarize(values: list) -> str:
    if not values:
        return "-"
    dist = " ".join(f"{v}:{c}" for v, c in sorted(Counter(values).items()))
    return (f"min {min(values)}, median {statistics.median(values):g}, mean {statistics.mean(values):.2f}, "
            f"max {max(values)}   [{dist}]")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("queries", help="multiseg_queries.jsonl (or precheck_passed.jsonl)")
    ap.add_argument("--csv", help="also write one row per (query, segment)")
    args = ap.parse_args()

    rows, plan_space, errors = [], [], Counter()
    with open(args.queries) as f:
        for n, line in enumerate(f):
            if not line.strip():
                continue
            mq = json.loads(line)
            mq.setdefault("query_id", n)
            try:
                r = segment_rows(mq)
            except Exception as e:     # noqa: BLE001
                errors[type(e).__name__] += 1
                continue
            rows += r
            space = 1
            for x in r:
                space *= x["subplans"]
            plan_space.append(space)

    k = max((r["segment"] for r in rows), default=0)
    print(f"queries: {len(plan_space)}" + (f"   (not parsed: {dict(errors)})" if errors else ""))
    for i in range(1, k + 1):
        seg = [r for r in rows if r["segment"] == i]
        print(f"\nsegment {i} ({len(seg)} queries)")
        print(f"  Cypher path hops      {summarize([r['path_hops'] for r in seg])}")
        print(f"  variable-length       {sum(r['varlength'] for r in seg)} queries")
        print(f"  tables joined (SQL)   {summarize([r['tables_joined'] for r in seg])}")
        print(f"  distinct table types  {summarize([r['table_types'] for r in seg])}")
        print(f"  movable relations     {summarize([r['movable'] for r in seg])}")
        print(f"  sub-plans             {summarize([r['subplans'] for r in seg])}")
        tables = Counter(t for r in seg for t in r["tables"].split())
        print(f"  tables used           {dict(tables.most_common())}")
        if i < k:
            print(f"  boundary              {dict(Counter(r['boundary'] for r in seg))}")
    print(f"\nplan space per query    {summarize(plan_space)}")
    print(f"segment executions      {sum(r['subplans'] for r in rows)} in total "
          f"(vs {sum(plan_space)} composite plans)")

    if args.csv:
        with open(args.csv, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0]))
            w.writeheader()
            w.writerows(rows)
        print(f"wrote {args.csv}")


if __name__ == "__main__":
    main()
