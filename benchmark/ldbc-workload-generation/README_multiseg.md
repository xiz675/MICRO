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
| 4. Pilot: bound vs. unbound per boundary | `python ../../system/multiseg_pilot.py queries.cypher out.jsonl` | per-plan timings |

## Decomposed form

For each segment i: `G_i` (Cypher, ids only) → table `neo4j` → `SQL_i` (property predicates plus,
for i < k, the boundary's GROUP BY / HAVING-style WHERE / ORDER BY / LIMIT) → table `seg{i}`.
For i > 1, `SQL_i` also joins `seg{i-1}` on the carried variables.

* `cypher`: canonical, unbound graph query (independent execution)
* `bound_cypher`: `UNWIND $seg{i-1} AS b MATCH (f:Person {id: b.fid}) ...` (push-back)
* `combined_sql`: all SQL stages as one CTE chain over `neo4j1..neo4jk`
* `full_sql`: all-PostgreSQL equivalent (edge tables), for XDB / single-model runs; `None` for
  variable-length paths, same as the single-segment pipeline

## Query rules enforced by the checker

* only `MATCH / WHERE / WITH / ORDER BY / LIMIT / RETURN`; no `STARTS WITH`, `CONTAINS`, `OPTIONAL MATCH`, `UNWIND`
* segment i+1 starts from a node variable carried by the preceding `WITH`
* `WHERE` / `ORDER BY` after `WITH` or `RETURN` reference aliases only
