"""
Multi-segment CMGRJ workload generation for CM-LDBC (TKDE extension).

Same philosophy as llm_workload_generation.py: the LLM only writes Cypher on the
*virtual graph*; decomposition into Cypher+SQL stays deterministic.

A multi-segment query is a chain of k MATCH segments separated by *boundary*
WITH blocks:

    MATCH seg1 [WHERE ...]
    WITH carried_vars, AGG(...) AS a [WHERE a ...] [ORDER BY a LIMIT n]   <- boundary 1
    MATCH seg2 (starts from a carried var) [WHERE ...]
    ...
    RETURN ...

A boundary is a *cross-model blocking boundary* (i.e. the query is irreducible to a
single-segment CMGRJ) iff
  (1) it is blocking: contains an aggregation or a LIMIT, and
  (2) its input depends on a table-resident property: a non-id property is used in the
      preceding segment's predicates, in the aggregate arguments, or in ORDER BY keys.
In CM-LDBC the graph only keeps `id`, so (2) means "touches any non-id property".
If (2) fails, the boundary can run entirely inside Neo4j and the decomposer would
fold it into one graph query.
"""
import json
import os
import random
import re
from dataclasses import dataclass, field

from llm_workload_generation import extended_rel_map
from utils.cypher_rewrite_util import (find_all_keywords_match, CYPHER_CLAUSE,
                                       VAR_PATTERN_WITH_OPTIONAL_PROPS, VAR_PROP_PATTERN)

# ---------------------------------------------------------------------------
# Schema (identical to the single-segment generator)
# ---------------------------------------------------------------------------
NODE_PROPERTY = """
Node properties:
Country, City, Place: id, name
Organisation, University, Company: id, name
TagClass: id, name
Tag: id, name
Forum: creationDate, id, title
Person: creationDate, id, firstName, lastName, gender, birthday, speaks, locationIP, browserUsed, email
Post, Comment, Message: creationDate, id, locationIP, browserUsed, content, length
Country or City are Place
Post or Comment are Message
University or Company are Organisation
"""
RELATIONSHIP = ("Relationship type with a list of source node label and target node label: \n" +
                "\n".join(r + ": " + ", ".join(f"({a}, {b})" for a, b in sorted(extended_rel_map[r]))
                          for r in extended_rel_map))
SCHEMA_DESCRIPTION = NODE_PROPERTY + "\n" + RELATIONSHIP

# properties NOT in neo4j (same as crossmodel_query_rewrite.py)
PROP_MAPPING = {
    "City": ["name"], "Place": ["name"], "Country": ["name"], "Continent": ["name"],
    "Organisation": ["name"], "University": ["name"], "Company": ["name"],
    "TagClass": ["name"], "Tag": ["name"],
    "Forum": ["title", "creationDate"],
    "Person": ["email", "firstName", "lastName", "gender", "birthday", "speaks", "locationIP", "browserUsed"],
    "Post": ["creationDate", "content", "length", "locationIP", "browserUsed"],
    "Comment": ["creationDate", "content", "length", "locationIP", "browserUsed"],
    "Message": ["creationDate", "content", "length", "locationIP", "browserUsed"],
}

# ---------------------------------------------------------------------------
# Shape specification: diversity is controlled here, not left to the LLM
# ---------------------------------------------------------------------------
BOUNDARY_OPS = {
    "topk": "keep the top-$k groups: `WITH x, count(...) AS c ORDER BY c DESC LIMIT $k`",
    "having": "keep groups passing a threshold: `WITH x, count(...) AS c WHERE c > $n`",
    "attr_agg": ("aggregate a node property (avg/min/max over a non-id property such as length, "
                 "birthday, creationDate), then `ORDER BY` that aggregate and `LIMIT $k` (no threshold)"),
}
ANCHOR_LABELS = ["Person", "Forum", "Tag", "TagClass", "Country", "City", "University", "Company", "Post", "Comment"]
FINAL_OPS = {
    "project": "return node properties (no aggregation)",
    "group_count": "group by one or two node properties and count",
    "topk": "group, count and return the top results with ORDER BY ... LIMIT",
}


@dataclass
class ShapeSpec:
    k: int
    anchor: str
    boundaries: list
    hops: list
    varlength_segment: int  # -1 = none
    final_op: str

    def to_prompt(self) -> str:
        lines = [f"- Number of MATCH segments: exactly {self.k}.",
                 f"- The first segment starts from a {self.anchor} node."]
        for i, b in enumerate(self.boundaries):
            lines.append(f"- Boundary {i + 1} (between segment {i + 1} and {i + 2}): {BOUNDARY_OPS[b]}.")
        for i, h in enumerate(self.hops):
            vl = " Use one variable-length KNOWS*1..2 pattern here." if i == self.varlength_segment else ""
            lines.append(f"- Segment {i + 1}: about {h} relationship hop(s).{vl}")
        lines.append(f"- Final RETURN: {FINAL_OPS[self.final_op]}.")
        return "\n".join(lines)


# Target workload distribution (see discussion): 2-segment queries dominate, 3-segment queries
# exercise two round trips; 4+ segments are excluded (plan space and LLM yield both degrade).
K_DIST = {2: 0.65, 3: 0.35}
BOUNDARY_DIST = {"topk": 0.4, "having": 0.4, "attr_agg": 0.2}
# LIMIT values are filled by the script, not the LLM, so that intermediate result sizes are spread
# over orders of magnitude (this is what moves the push-back vs. independent-execution trade-off).
LIMIT_TIERS = [10, 100, 1000, 10000]


def sample_shape(rng: random.Random, k: int = None) -> ShapeSpec:
    k = k or rng.choices(list(K_DIST), weights=list(K_DIST.values()))[0]
    return ShapeSpec(
        k=k,
        anchor=rng.choice(ANCHOR_LABELS),
        boundaries=[rng.choices(list(BOUNDARY_DIST), weights=list(BOUNDARY_DIST.values()))[0]
                    for _ in range(k - 1)],
        hops=[rng.choice([1, 2, 3]) for _ in range(k)],
        varlength_segment=rng.choice([-1, -1, -1, rng.randrange(k)]),
        final_op=rng.choice(list(FINAL_OPS)),
    )


def fill_limits(cypher: str, rng: random.Random) -> tuple[str, list]:
    """Replace every `LIMIT $x` in boundaries with a sampled tier; the final RETURN LIMIT is kept small."""
    chosen = []
    parts = re.split(r"(?i)(\breturn\b)", cypher, maxsplit=1)

    def _sub(m):
        v = rng.choice(LIMIT_TIERS)
        chosen.append(v)
        return f"LIMIT {v}"
    head = re.sub(r"(?i)LIMIT\s+\$\w+", _sub, parts[0])
    tail = re.sub(r"(?i)LIMIT\s+\$\w+", "LIMIT 20", "".join(parts[1:]))
    return head + tail, chosen


# ---------------------------------------------------------------------------
# Few-shot pool (rotated per call so the LLM does not copy one pattern)
# ---------------------------------------------------------------------------
FEW_SHOT = [
    # k=2, top-k boundary
    """MATCH (p:Person {firstName: $firstName})-[:KNOWS*1..2]-(f:Person)<-[:HAS_CREATOR]-(m:Post)
WHERE f.birthday > $birthday AND m.creationDate > $date
WITH f, count(m) AS postCount ORDER BY postCount DESC LIMIT $k
MATCH (f)<-[:HAS_CREATOR]-(:Post)<-[:REPLY_OF]-(c:Comment)-[:HAS_TAG]->(t:Tag)
WHERE c.length > $length
RETURN t.name, count(c) AS replyCount""",
    # k=2, having boundary
    """MATCH (co:Country {name: $country})<-[:IS_PART_OF]-(:City)<-[:IS_LOCATED_IN]-(p:Person)<-[:HAS_MEMBER]-(fo:Forum)
WHERE p.gender = $gender
WITH fo, count(p) AS localMembers WHERE localMembers > $n
MATCH (fo)-[:CONTAINER_OF]->(m:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE m.creationDate > $date
RETURN tc.name, count(DISTINCT fo) AS forumCount""",
    # k=3, two round trips
    """MATCH (tc:TagClass {name: $tagClass})<-[:HAS_TYPE]-(t:Tag)<-[:HAS_TAG]-(c:Comment)
WHERE c.creationDate > $date
WITH t, count(c) AS cnt ORDER BY cnt DESC LIMIT $k
MATCH (t)<-[:HAS_INTEREST]-(p:Person)-[:WORK_AT]->(o:Company)-[:IS_LOCATED_IN]->(co:Country)
WHERE co.name = $country
WITH p, count(DISTINCT t) AS sharedTags WHERE sharedTags >= $n
MATCH (p)-[:KNOWS]-(q:Person)
WHERE q.browserUsed = $browser
RETURN p.id, p.firstName, count(q) AS friendCount""",
    # k=2, attribute aggregation boundary
    """MATCH (f:Forum)-[:CONTAINER_OF]->(m:Post)-[:HAS_TAG]->(t:Tag {name: $tag})
WITH f, avg(m.length) AS avgLen ORDER BY avgLen DESC LIMIT $k
MATCH (f)-[:HAS_MODERATOR]->(md:Person)-[:STUDY_AT]->(u:University)
RETURN u.name, count(DISTINCT f) AS forumCount""",
]

PROMPT_TEMPLATE = """You are generating a benchmark of multi-stage Cypher queries over the graph schema below.

{schema}

Generate {n} Cypher queries. Every query MUST follow this shape specification:
{shape}

Hard rules (a query violating any rule is discarded):
1. Read-only. Use only MATCH, WHERE, WITH, ORDER BY, LIMIT, RETURN. No OPTIONAL MATCH, UNWIND, CALL, subqueries, EXISTS, or list comprehensions.
2. Segments are separated by WITH. Each boundary WITH must contain an aggregation (count/avg/min/max/sum) and may be followed by WHERE on the aggregate or ORDER BY ... LIMIT. WHERE and ORDER BY after a WITH or RETURN may only refer to aliases defined in that WITH/RETURN (e.g. `ORDER BY postCount DESC`), never to `var.property`.
3. Segment i+1 must start from a node variable carried through the preceding WITH, written without a label, e.g. `MATCH (f)-[...]->...`.
4. Every segment must contain at least one predicate on a node property other than `id` (inline `{{prop: $p}}` or in WHERE), or the boundary must aggregate a property other than `id`.
5. Never filter on `id`. When a variable is first introduced it must carry a label, e.g. `(m:Post)`. Only use labels, properties and relationship directions from the schema. There are no relationship properties.
6. Use $placeholders for every constant, including LIMIT ($k) and thresholds ($n). Do not use equality on datetime properties. Do not use STARTS WITH, ENDS WITH, CONTAINS or regex.
7. The queries must be semantically meaningful: each stage should narrow down or rank entities that the next stage explores. Write a one-sentence natural-language description for each.
8. The {n} queries must differ from each other in node labels and relationship types used.

Examples of the expected style (they do not follow the shape specification above):
{examples}

Return JSON only: {{"queries": [{{"nl": "...", "cypher": "..."}}, ...]}}
"""


def build_prompt(spec: ShapeSpec, rng: random.Random, n: int = 5, n_shots: int = 2) -> str:
    shots = rng.sample(FEW_SHOT, n_shots)
    return PROMPT_TEMPLATE.format(schema=SCHEMA_DESCRIPTION, n=n, shape=spec.to_prompt(),
                                  examples="\n\n".join(shots))


# HAVING-style thresholds on count aggregates; non-count thresholds are not filled (scale unknown) and the
# collector skips such queries -> the prompt asks for top-k instead of thresholds on avg/min/max.
COUNT_THRESHOLD_TIERS = [2, 3, 5, 10, 20]
_BOUNDARY_WHERE = re.compile(
    r"(?is)\bWITH\b((?:(?!\bMATCH\b|\bRETURN\b).)*?)\bWHERE\b((?:(?!\bMATCH\b|\bRETURN\b|\bORDER\s+BY\b|\bLIMIT\b).)*)")


def fill_thresholds(cypher: str, rng: random.Random) -> tuple[str, list]:
    """Replace `$x` in a WHERE right after WITH (HAVING-like) with a tier, if it compares a count alias."""
    chosen = []

    def _with(m):
        projection, cond = m.group(1), m.group(2)
        count_aliases = set(re.findall(r"(?i)\bcount\s*\([^)]*\)\s+AS\s+(\w+)", projection))

        def _sub(mm):
            if mm.group(1) in count_aliases:
                v = rng.choice(COUNT_THRESHOLD_TIERS)
                chosen.append(v)
                return f"{mm.group(1)} {mm.group(2)} {v}"
            return mm.group(0)
        cond = re.sub(r"(\w+)\s*(>=|<=|>|<|=)\s*\$\w+", _sub, cond)
        return m.group(0)[:m.start(2) - m.start(0)] + cond
    return _BOUNDARY_WHERE.sub(_with, cypher), chosen


def _signature(cypher: str) -> str:
    return re.sub(r"\s+", " ", re.sub(r"\$\w+|\b\d+\b", "?", cypher)).strip().lower()


def generate(openai_client, out_path: str, target_valid: int = 100, per_call: int = 5, max_calls: int = 300,
             seed: int = 0, model: str = "gpt-4o", rejected_path: str = None, k: int = None):
    """Call the LLM until `target_valid` queries pass the static checker + deterministic decomposition.
    Passing queries go to out_path, the rest (with the reason) to rejected_path.
    k: only generate (and keep) k-segment queries; None samples k from K_DIST."""
    from multiseg_query_rewrite import decompose_multiseg   # local import: that module imports this one
    rng = random.Random(seed)
    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    rejected_path = rejected_path or out_path.replace(".jsonl", "") + "_rejected.jsonl"
    seen, n_valid, n_calls, k_count = set(), 0, 0, {}
    with open(out_path, "a") as f, open(rejected_path, "a") as rej:
        while n_valid < target_valid and n_calls < max_calls:
            n_calls += 1
            spec = sample_shape(rng, k=k)
            try:
                resp = openai_client.chat.completions.create(
                    model=model, temperature=0.8, max_tokens=4000,
                    response_format={"type": "json_object"},
                    messages=[{"role": "user", "content": build_prompt(spec, rng, n=per_call)}])
                queries = json.loads(resp.choices[0].message.content)["queries"]
            except Exception as e:     # noqa: BLE001  (API error, bad JSON)
                print(f"call {n_calls}: {e}")
                continue
            for q in queries:
                if not isinstance(q, dict) or "cypher" not in q:
                    continue
                q["cypher"], q["boundary_limits"] = fill_limits(q["cypher"], rng)
                q["cypher"], q["boundary_thresholds"] = fill_thresholds(q["cypher"], rng)
                rec = {"spec": spec.__dict__, **q}
                sig = _signature(q["cypher"])
                try:
                    if sig in seen:
                        raise ValueError("duplicate")
                    mq = decompose_multiseg(q["cypher"])
                    if k is not None and mq.k != k:
                        raise ValueError(f"expected {k} segments, got {mq.k}")
                    if any("$" in st.limit + st.post_where for st in mq.stages):
                        raise ValueError("unfilled boundary threshold")
                except Exception as e:     # noqa: BLE001
                    rej.write(json.dumps({**rec, "reason": str(e)}) + "\n")
                    continue
                seen.add(sig)
                n_valid += 1
                k_count[mq.k] = k_count.get(mq.k, 0) + 1
                f.write(json.dumps(rec) + "\n")
                f.flush()
            print(f"call {n_calls}: {n_valid}/{target_valid} valid, k distribution {k_count}")
    return n_valid


# ---------------------------------------------------------------------------
# Deterministic static checker / segment splitter
# ---------------------------------------------------------------------------
AGG_FUNC = re.compile(r'\b(count|avg|min|max|sum|collect)\s*\(\s*(distinct\s+)?([^)]*)\)', re.IGNORECASE)
FORBIDDEN = re.compile(r'\b(starts\s+with|ends\s+with|contains|optional\s+match|unwind|call|exists)\b|=~',
                       re.IGNORECASE)


def _strip_kw(text: str, kw_regex: str) -> str:
    return re.sub(rf"^\s*{kw_regex}\s+", "", text, flags=re.IGNORECASE).strip()


@dataclass
class Segment:
    match_parts: list                                 # MATCH / WHERE clauses of this segment (raw text)
    with_items: str = ""                              # projection of the boundary WITH ("" for the last)
    with_distinct: bool = False
    post_where: str = ""                              # predicate of a WHERE right after the WITH (HAVING-like)
    order_by: str = ""                                # "ORDER BY ..." clause of the boundary
    limit: str = ""                                   # "LIMIT ..." clause of the boundary
    blocking: bool = False
    pg_props: set = field(default_factory=set)        # table-resident props feeding the boundary
    carried: list = field(default_factory=list)       # node vars projected by the boundary WITH

    @property
    def match_text(self) -> str:
        return "\n".join(self.match_parts)

    @property
    def is_boundary(self) -> bool:
        return self.with_items != ""


@dataclass
class CheckResult:
    ok: bool
    reason: str = ""
    segments: list = field(default_factory=list)
    return_items: str = ""                            # projection of the final RETURN
    return_order_by: str = ""
    return_limit: str = ""
    labels: dict = field(default_factory=dict)


def _pg_list(label: str) -> list:
    # subset labels (Person1, Forum2, ...) share the base label's properties
    return PROP_MAPPING.get(label) or PROP_MAPPING.get(re.sub(r'\d+$', '', label), [])


def _var_labels(query: str) -> dict:
    labels = {}
    for m in VAR_PATTERN_WITH_OPTIONAL_PROPS.finditer(query):
        var, label = m.group(1), m.group(2)
        if var and var not in labels:
            labels[var] = label
    return labels


def _pg_props(text: str, labels: dict, inline: bool = True) -> set:
    found = set()
    for m in VAR_PROP_PATTERN.finditer(text):
        var, prop = m.group(1), m.group(2)
        if var in labels and prop in _pg_list(labels[var]):
            found.add(f"{var}.{prop}")
    if inline:
        for m in VAR_PATTERN_WITH_OPTIONAL_PROPS.finditer(text):
            var, label, props = m.groups()
            if props:
                for p in props.split(","):
                    key = p.split(":")[0].strip()
                    if key in _pg_list(label):
                        found.add(f"{var or '_'}:{label}.{key}")
    return found


def check_multiseg(query: str, expected_k: int = None) -> CheckResult:
    query = query.strip().rstrip(";")
    if FORBIDDEN.search(query):
        return CheckResult(False, "forbidden construct")
    labels = _var_labels(query)
    clauses = find_all_keywords_match(query, CYPHER_CLAUSE)

    result = CheckResult(False, labels=labels)
    segments = [Segment([])]
    state = "match"                  # match -> boundary -> (match ...) -> return
    for c in clauses:
        kw, text = c.keyword.strip(), c.get_clause_text()
        if kw == "match":
            if state == "boundary":
                segments.append(Segment([]))
            elif state == "return":
                return CheckResult(False, "MATCH after RETURN")
            state = "match"
            segments[-1].match_parts.append(text)
        elif kw in ("with", "with distinct"):
            if state == "boundary":
                return CheckResult(False, "two consecutive WITH clauses")
            state = "boundary"
            segments[-1].with_distinct = kw == "with distinct"
            segments[-1].with_items = _strip_kw(text, r"with(\s+distinct)?")
        elif kw == "return":
            state = "return"
            result.return_items = _strip_kw(text, "return")
        elif kw == "where":
            if state == "match":
                segments[-1].match_parts.append(text)
            elif state == "boundary":
                segments[-1].post_where = _strip_kw(text, "where")
            else:
                return CheckResult(False, "WHERE after RETURN")
        elif kw == "order by":
            if state == "boundary":
                segments[-1].order_by = text
            elif state == "return":
                result.return_order_by = text
            else:
                return CheckResult(False, "ORDER BY inside MATCH")
        elif kw == "limit":
            if state == "boundary":
                segments[-1].limit = text
            elif state == "return":
                result.return_limit = text
            else:
                return CheckResult(False, "LIMIT inside MATCH")
        else:
            return CheckResult(False, f"unsupported clause {kw}")
    if state != "return":
        return CheckResult(False, "query does not end with RETURN")
    if segments[-1].is_boundary:
        return CheckResult(False, "trailing WITH before RETURN")

    for seg in segments[:-1]:
        seg.blocking = bool(AGG_FUNC.search(seg.with_items)) or seg.limit != ""
        proj = re.split(r"\s*,\s*", seg.with_items)
        seg.carried = [p.strip() for p in proj if p.strip() in labels]
        # props feeding the boundary: segment predicates, agg args, ORDER BY keys
        agg_args = " ".join(m.group(3) for m in AGG_FUNC.finditer(seg.with_items))
        seg.pg_props = _pg_props(seg.match_text, labels) | _pg_props(agg_args + " " + seg.order_by, labels, False)
    result.segments = segments

    k = len(segments)
    if k < 2:
        result.reason = "single segment"
        return result
    if expected_k is not None and k != expected_k:
        result.reason = f"expected {expected_k} segments, got {k}"
        return result
    for i, seg in enumerate(segments[:-1]):
        if not seg.blocking:
            result.reason = f"boundary {i + 1} not blocking (foldable)"
        elif not seg.pg_props:
            result.reason = f"boundary {i + 1} has no table-resident input (runs inside Neo4j)"
        elif not seg.carried:
            result.reason = f"boundary {i + 1} carries no node variable"
        elif not any(re.search(rf"\(\s*{re.escape(v)}\s*[)\-:]", segments[i + 1].match_text) for v in seg.carried):
            result.reason = f"segment {i + 2} does not start from a carried variable"
        if result.reason:
            return result
    result.ok, result.reason = True, "ok"
    return result


def _selftest():
    for q in FEW_SHOT:
        r = check_multiseg(q)
        print(r.ok, r.reason, [(s.carried, sorted(s.pg_props)) for s in r.segments[:-1]])

    # negative: boundary only counts topology -> can run entirely in Neo4j
    neg = """MATCH (p:Person {id: $pid})-[:KNOWS]-(f:Person)<-[:HAS_CREATOR]-(m:Post)
WITH f, count(m) AS c ORDER BY c DESC LIMIT $k
MATCH (f)-[:WORK_AT]->(o:Company)
RETURN o.name"""
    print(check_multiseg(neg).reason)
    neg2 = """MATCH (p:Person)-[:KNOWS]-(f:Person) WHERE p.gender = $g
WITH f
MATCH (f)-[:WORK_AT]->(o:Company)
RETURN o.name"""
    print(check_multiseg(neg2).reason)

    print("\n--- sample prompt ---")
    rng = random.Random(1)
    spec = sample_shape(rng)
    print(build_prompt(spec, rng))



if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser(description="multi-segment CMGRJ workload generation")
    ap.add_argument("--generate", action="store_true", help="call the LLM (needs OPENAI_API_KEY)")
    ap.add_argument("--target", type=int, default=100, help="number of statically valid queries to collect")
    ap.add_argument("--out", default="multiseg_llm.jsonl")
    ap.add_argument("--model", default="gpt-4o")
    ap.add_argument("--per-call", type=int, default=5)
    ap.add_argument("--max-calls", type=int, default=300)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--k", type=int, choices=[2, 3], default=None,
                    help="only generate k-segment queries (default: mix of 2 and 3, see K_DIST)")
    a = ap.parse_args()
    if not a.generate:
        _selftest()
    else:
        from openai import OpenAI
        from utils.env_util import load_env
        load_env()                                    # OPENAI_API_KEY from <repo>/.env (git-ignored)
        if not os.environ.get("OPENAI_API_KEY"):
            raise SystemExit("OPENAI_API_KEY is not set: put it in <repo>/.env (see .env.example)")
        generate(OpenAI(api_key=os.environ["OPENAI_API_KEY"]), a.out, target_valid=a.target,
                 per_call=a.per_call, max_calls=a.max_calls, seed=a.seed, model=a.model, k=a.k)
        # next: python multiseg_query_rewrite.py <out> <prefix>; then system/multiseg_collect.py --precheck-only
