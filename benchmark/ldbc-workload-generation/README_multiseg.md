# Multi-segment CMGRJ workload (CM-LDBC)

A k-segment query is written on the virtual graph as a chain of `MATCH` segments separated by
boundary `WITH` blocks. A `WITH` is a segment boundary only if it is

1. **blocking**: it has an aggregation or a `LIMIT`, and
2. **cross-model**: its input uses a table-resident (non-`id`) property, either in the preceding
   segment's predicates, in the aggregate arguments, or in the `ORDER BY` keys.

Anything else (a pass-through `WITH`, or a `count` over graph topology only) can run inside Neo4j
and is rejected, so every query in the workload is irreducible to a single-segment CMGRJ.

## Pipeline

| Step | Script | Output |
|---|---|---|
| 1. LLM generation (shape spec sampled per call, LIMIT tiers filled by script) | `llm_multiseg_generation.py` → `generate()` | `multiseg_llm.jsonl` |
| 2. Edge-direction correction (unchanged) | `llm_workload_correction.py` | |
| 3. Deterministic decomposition + validation | `python multiseg_query_rewrite.py multiseg_llm.jsonl <prefix>` | `<prefix>multiseg_queries.{jsonl,txt}`, `<prefix>multiseg_queries_full.sql` |
| 4. Segment-wise plan timing + offline composition | `python ../../system/multiseg_collect.py <prefix>multiseg_queries.jsonl <result_dir>` | `multiseg_plans_with_runtime.jsonl` |

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

`--validate N` runs N sampled composite plans end-to-end (parallel branches in threads) to measure
the composition error. `test_multiseg_collect.py` checks plan equivalence and the composition on a
synthetic CM-LDBC in PostgreSQL with an emulated Neo4j (no Neo4j needed).

## Things that must be instantiated before collection

* `$param` filters are not executed (CM-LDBC convention: T1/T2 tables are pre-filtered), but
  **LIMIT values and HAVING-style thresholds are**, so they need concrete numbers (the generator
  fills LIMIT tiers; calibrate thresholds from the aggregate's distribution). The collector skips
  queries that still contain them.
* Filters on `id` stay in the Cypher, so the prompt forbids them.
* Top-k is made deterministic: the decomposer appends all output columns as tie-breakers
  (`ORDER BY cnt DESC, 1, 2`). Without this, ties make `seg{i}` plan-dependent.
