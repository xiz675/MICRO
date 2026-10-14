"""
Export multi-segment collection results (multiseg_plans_with_runtime.jsonl) in CMLero's input format.

For k-segment queries (default k=2) it writes, per split (train/ and test/):

    seg1/  cypher_raw_plans.json  workloads.json  all_plans_with_runtime.json  rel_stats.json
    seg2/  (same four files)
    composite.json

* seg<i>/ has exactly the ICDE format (CMLero/load_workloads.py: prepare_input(prefix)), one entry per
  query, aligned across seg1/, seg2/ and composite.json (entry q is the same query everywhere).
  - cypher_raw_plans.json: EXPLAIN of segment i's canonical Cypher (nothing moved)
  - workloads.json: tuples of the plan that moves every movable relation of segment i
    [graph var.id, table_alias.col, graph label, table label]; seg{i-1} has table label "SEG"
  - all_plans_with_runtime.json: every subplan of segment i, {"plan": tuples, "time": seconds}, where
    time is the work of segment i alone:
        seg1:                      pre_base + graph + sql
        seg i>1, seg not moved:    pre_base + graph + sql(R_ia) + R_ib
        seg i>1, seg moved:        pre_base + move_seg + graph + sql
    timeouts get OUT_OF_TIME_QUERY_TIME, as in the ICDE results
  - rel_stats.json: base-table sizes (from --rel-stats, e.g. the ICDE file of the same configuration)
    plus "SEG" = median actual size of the exported seg tables (CMLero needs a size for every moved
    relation; no per-query seg size is exposed)
* composite.json: per query, every composite plan with its composed end-to-end latency
    {"query_id", "original", "composites": [{"plans": [j1, j2], "seg1_moved": bool, "latency": s}]}
  j_i indexes all_plans_with_runtime.json of seg<i> for that query. Whether seg{i-1} is moved (sequential)
  or not (parallel) is also visible in the seg<i> plan itself: it contains a tuple with table label "SEG".
  Pairs are not materialised: build them within a query, as CMLero's get_pairwise_plan does.

Queries with plan errors or inconsistent outputs (usable_for_training=false), a failed EXPLAIN, or a
different number of segments are skipped and reported.

    python multiseg_export.py res/multiseg_plans_with_runtime.jsonl export/ \
        --rel-stats results/sf10-t1/train/rel_stats.json --test-ratio 0.2
"""
import argparse
import glob
import json
import os
import random
from collections import Counter

OUT_OF_TIME_QUERY_TIME = 100000      # same constant as utils/run_plan_util.py and multiseg_collect.py


def segment_time(p: dict, rib_time: float) -> float:
    t = p["timings"]
    if t.get("timeout"):
        return OUT_OF_TIME_QUERY_TIME
    work = t.get("pre_base", 0) + t.get("move_seg", 0) + t.get("graph", 0) + t.get("sql", 0)
    if p.get("split"):
        work += rib_time
    return work


def export_query(rec: dict) -> dict:
    """Returns the per-segment ICDE entries and the composite entry for one collected query."""
    k = rec["k"]
    segs = []
    for i in range(k):
        plans = rec["segments"][i]
        rib = rec.get("rib", {}).get(str(i + 1), {}).get("rib", 0.0) or 0.0
        full = max(plans, key=lambda p: len(p["moved"]))          # moves every movable relation
        segs.append({
            "raw_plan": rec["neo4j_raw_plans"][i],
            "workload": full["plan_tuples"],
            "plans": [{"plan": p["plan_tuples"], "time": segment_time(p, rib)} for p in plans],
        })
    composites = [{"plans": c["combo"],
                   "seg1_moved": bool(rec["segments"][1][c["combo"][1]]["seg_moved"]) if k > 1 else False,
                   "latency": OUT_OF_TIME_QUERY_TIME if c.get("timeout") else c["latency"]}
                  for c in rec["composite"] if not c.get("error")]
    return {"segments": segs, "composite": {"query_id": rec.get("query_id"), "original": rec["original"],
                                            "composites": composites}}


def seg_sizes(rec: dict) -> list:
    """actual size of seg1..seg{k-1} (rows of R_ib output or of a moved-seg plan's output)"""
    sizes = []
    for i in range(rec["k"] - 1):
        rib = rec.get("rib", {}).get(str(i + 1))
        if rib and rib.get("rows") is not None:
            sizes.append(rib["rows"])
            continue
        rows = [p["timings"].get("sql_rows") for p in rec["segments"][i]
                if not p.get("split") and p["timings"].get("status") == "ok"]
        if rows:
            sizes.append(rows[0])
    return sizes


def write_split(out_dir: str, entries: list, k: int, rel_stats: dict):
    os.makedirs(out_dir, exist_ok=True)
    for i in range(k):
        d = os.path.join(out_dir, f"seg{i + 1}")
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, "cypher_raw_plans.json"), "w") as f:
            json.dump([e["segments"][i]["raw_plan"] for e in entries], f, indent=4)
        with open(os.path.join(d, "workloads.json"), "w") as f:
            json.dump([e["segments"][i]["workload"] for e in entries], f, indent=4)
        with open(os.path.join(d, "all_plans_with_runtime.json"), "w") as f:
            json.dump([e["segments"][i]["plans"] for e in entries], f, indent=4)
        with open(os.path.join(d, "rel_stats.json"), "w") as f:
            json.dump(rel_stats, f, indent=2)
    with open(os.path.join(out_dir, "composite.json"), "w") as f:
        json.dump([e["composite"] for e in entries], f, indent=2)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("results", nargs="+",
                    help="multiseg_plans_with_runtime.jsonl file(s); several shards are concatenated")
    ap.add_argument("out_dir")
    ap.add_argument("--rel-stats", required=True,
                    help="base-table sizes, e.g. system/results/sf10-t1/train/rel_stats.json")
    ap.add_argument("--k", type=int, default=2, help="export only k-segment queries")
    ap.add_argument("--test-ratio", type=float, default=0.2, help="0 writes everything to train/")
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--include-inconsistent", action="store_true",
                    help="also export queries whose plans ran but whose outputs differ (checksum mismatch); queries "
                         "with failed plans are still skipped")
    args = ap.parse_args()

    paths = [p for pat in args.results for p in sorted(glob.glob(pat))]
    recs, skipped = [], Counter()
    for path in paths:
        with open(path) as f:
            for line in f:
                rec = json.loads(line)
                if rec.get("k") != args.k:
                    skipped[f"k={rec.get('k')}"] += 1
                elif not rec.get("usable_for_training") and not (
                        args.include_inconsistent and not any(c["plan_errors"] for c in rec.get("consistency", []))):
                    skipped["plan errors / inconsistent outputs"] += 1
                elif any(p is None for p in rec.get("neo4j_raw_plans", [None])) or \
                        len(rec.get("neo4j_raw_plans", [])) != args.k:
                    skipped["missing EXPLAIN plan"] += 1
                elif not any(not c.get("error") for c in rec.get("composite", [])):
                    skipped["no composite plan"] += 1
                else:
                    recs.append(rec)

    with open(args.rel_stats) as f:
        rel_stats = json.load(f)
    sizes = sorted(s for r in recs for s in seg_sizes(r))
    rel_stats["SEG"] = sizes[len(sizes) // 2] if sizes else 1
    tables = {t[-1] for r in recs for seg in r["segments"] for p in seg for t in p["plan_tuples"]}
    missing = sorted(tables - set(rel_stats))
    if missing:
        raise SystemExit(f"--rel-stats has no size for {missing}; add them (CMLero asserts every moved "
                         f"relation has a size)")

    entries = [export_query(r) for r in recs]
    idx = list(range(len(entries)))
    random.Random(args.seed).shuffle(idx)
    n_test = int(round(len(idx) * args.test_ratio))
    splits = {"train": sorted(idx[n_test:]), "test": sorted(idx[:n_test])} if n_test else {"train": idx}
    for name, ids in splits.items():
        write_split(os.path.join(args.out_dir, name), [entries[i] for i in ids], args.k, rel_stats)

    n_plans = [len(e["segments"][i]["plans"]) for e in entries for i in range(args.k)]
    print(json.dumps({"exported_queries": len(entries), **{f"{s}_queries": len(v) for s, v in splits.items()},
                      "skipped": dict(skipped), "SEG_size_used": rel_stats["SEG"],
                      "subplans_per_segment": dict(Counter(n_plans)),
                      "composites": sum(len(e["composite"]["composites"]) for e in entries)}, indent=1))


if __name__ == "__main__":
    main()
