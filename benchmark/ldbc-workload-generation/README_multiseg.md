# Multi-segment CMGRJ workload (CM-LDBC)

A k-segment query is written on the virtual graph as a chain of `MATCH` segments separated by
boundary `WITH` blocks. A `WITH` is a segment boundary only if it is

1. **blocking**: it has an aggregation or a `LIMIT`, and
2. **cross-model**: its input uses a table-resident (non-`id`) property, either in the preceding
   segment's predicates, in the aggregate arguments, or in the `ORDER BY` keys.

Anything else (a pass-through `WITH`, or a `count` over graph topology only) can run inside Neo4j
and is rejected, so every query in the workload is irreducible to a single-segment CMGRJ.

## Pipeline

```bash
cd benchmark/ldbc-workload-generation
# 1. generate until 100 queries pass the static checker + decomposition (needs OPENAI_API_KEY)
python llm_multiseg_generation.py --generate --target 100 --out multiseg_llm.jsonl
#    rejected queries and reasons: multiseg_llm_rejected.jsonl
# 2. (optional) edge-direction correction as before: llm_workload_correction.py
# 3. deterministic decomposition
python multiseg_query_rewrite.py multiseg_llm.jsonl out/
# 4. precheck on the real databases (EXPLAIN every plan + one canonical execution per query)
cd ../../system
python multiseg_collect.py ../benchmark/ldbc-workload-generation/out/multiseg_queries.jsonl res/ \
    --precheck-only --nj-uri ... --pg-db t1 --pg-pw ...
# 5. full collection on the queries that passed (the precheck runs again unless --no-precheck)
python multiseg_collect.py res/precheck_passed.jsonl res/ --no-precheck --validate 3 --nj-uri ... --pg-db t1 ...
# 6. export for CMLero: train/ and test/, each with seg1/ seg2/ (ICDE file format) + composite.json
python multiseg_export.py "res*/multiseg_plans_with_runtime.jsonl" export/ \
    --rel-stats results/sf10-t1/train/rel_stats.json --test-ratio 0.2
```

Export format (`system/multiseg_export.py`): `seg<i>/` holds the four ICDE files
(`cypher_raw_plans.json`, `workloads.json`, `all_plans_with_runtime.json`, `rel_stats.json`), one entry per
query, aligned across segments, so `CMLero/load_workloads.prepare_input("export/train/seg2")` works as
before. The previous segment's result appears as table label `"SEG"` in a plan's tuples: a seg2 plan
containing it waits for seg1 (sequential), otherwise it runs in parallel. `composite.json` lists every
composite plan per query (`plans: [j1, j2]` index the per-segment plan lists) with its composed latency.
Pairs are built within a query at training time, as in CMLero.

Running on several machines: give every node the same `precheck_passed.jsonl` and run shard i of n
(`--shard 0/5` ... `--shard 4/5`); queries are balanced by their number of segment-plan executions.
Use the same hardware type and the same deployment on all nodes (movement times are measured per node,
`movement_cache.json` is node-local); concatenate the `multiseg_plans_with_runtime.jsonl` files afterwards.

Generation fills LIMIT values from tiers (10/100/1000/10000) and HAVING thresholds on `count`
aggregates from tiers (2/3/5/10/20); thresholds on avg/min/max are not filled (the prompt asks for
top-k there) and such queries are rejected. Structural duplicates are rejected.

Checks:

| Layer | Where | Catches |
|---|---|---|
| static | generation (`check_multiseg` + `decompose_multiseg`) | wrong shape, foldable boundary, forbidden constructs, duplicates |
| precheck | `multiseg_collect.py` (`precheck_query`) | invalid Cypher/SQL on the real schema (`kind=query`), Cypher of a rewritten plan failing EXPLAIN (`kind=rewrite`), errors, timeouts, empty seg{i}/result, too slow (`--max-precheck-seconds`) |
| consistency | `multiseg_collect.py` (`collect_query`) | plans of a segment with different outputs (checksum), plans failing although the canonical plan ran -> `usable_for_training=false` |

## Decomposed form

For each segment i: `G_i` (Cypher, ids only) → table `neo4j` → `SQL_i` (property predicates plus,
for i < k, the boundary's GROUP BY / HAVING-style WHERE / ORDER BY / LIMIT) → table `seg{i}`.
For i > 1, `SQL_i` also joins `seg{i-1}` on the carried variables.

* `cypher`: canonical graph query (seg{i-1} not moved)
* `bound_cypher`: an `UNWIND`-based push-back variant, kept for reference only; the collector moves
  seg{i-1} with the same table-movement mechanism as the ICDE version (see below)
* `combined_sql`: all SQL stages as one CTE chain over `neo4j1..neo4jk`
* `full_sql`: all-PostgreSQL equivalent (edge tables), for XDB / single-model runs; `None` for
  variable-length paths, same as the single-segment pipeline

## Query rules enforced by the checker

* only `MATCH / WHERE / WITH / ORDER BY / LIMIT / RETURN`; no `STARTS WITH`, `CONTAINS`, `OPTIONAL MATCH`, `UNWIND`
* segment i+1 starts from a node variable carried by the preceding `WITH`
* `WHERE` / `ORDER BY` after `WITH` or `RETURN` reference aliases only

## Plan space and training-data collection (`system/multiseg_collect.py`)

Segment i's movable relations are its vertex-table joins plus, for i > 1, the previous segment's
result `seg{i-1}`; a plan is a subset moved into Neo4j (`apoc.load.jdbc` -> `:<label>T` nodes, as in
the ICDE version). Total plans: `prod_i 2^(n_i + [i>1])`.

* `seg{i-1}` moved -> segment i waits for it (sequential)
* not moved -> segment i runs in parallel; its SQL is split into `R_ia` (plan-specific, canonical
  projection) and `R_ib` (join with `seg{i-1}` + group/having/order/limit, identical for all plans)

Each component runs once (`sum_i 2^(n_i + [i>1]) + (k-1)` executions) and latencies are composed:

    end_1 = T1(p1)
    end_i = max(end_{i-1}, pre_i + G_i + R_ia) + R_ib                      seg not moved
    end_i = max(end_{i-1}, pre_i) + move_seg + G_i + R_i                   seg moved

Movement reuse (default): moving a relation costs the same in every plan that moves it, so each
(table, column set) is loaded 3 times into a scratch label and the median is cached
(`movement_cache.json`, shared across queries/runs); base tables stay in Neo4j under a persistent label
(`MS_<table>T`), seg{i-1} is loaded once per segment and deleted at the end of the query. Movement time
still enters every composed latency. `--no-movement-reuse` gives the per-plan baseline (for reporting
the collection-time saving); `--reset-persistent` after switching T1/T2 or reloading Neo4j.

`--validate N` runs N sampled composite plans end-to-end (parallel branches in threads) to measure
the composition error; it runs after the collection on a clean graph with the real per-plan flow
(`validation.jsonl`, median relative error in the summary). `test_multiseg_collect.py` checks plan equivalence and the composition on a
synthetic CM-LDBC in PostgreSQL with an emulated Neo4j (no Neo4j needed).

## Things that must be instantiated before collection

* `$param` filters are not executed (CM-LDBC convention: T1/T2 tables are pre-filtered), but
  **LIMIT values and HAVING-style thresholds are**, so they need concrete numbers (the generator
  fills LIMIT tiers; calibrate thresholds from the aggregate's distribution). The collector skips
  queries that still contain them.
* Filters on `id` stay in the Cypher, so the prompt forbids them.
* Top-k is made deterministic: the decomposer appends all output columns as tie-breakers
  (`ORDER BY cnt DESC, 1, 2`). Without this, ties make `seg{i}` plan-dependent.
