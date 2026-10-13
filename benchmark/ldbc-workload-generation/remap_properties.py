"""
Remap node properties that are not in the CM-LDBC property tables to ones that are, keeping the query shape.

The first workload was generated with the full LDBC schema (birthday, browserUsed, locationIP, email, speaks),
but the PostgreSQL tables only hold creationDate/firstName/lastName/gender (Person) and creationDate/content/
length (messages); a RETURN/GROUP BY on a missing column fails in SQL. Each missing property is replaced by an
existing property of the same label with a similar role (date -> date, categorical -> categorical), so the
segments, joins and plan space stay the same.

    python remap_properties.py workload/multiseg_llm.jsonl workload/multiseg_llm_remapped.jsonl
    python multiseg_query_rewrite.py workload/multiseg_llm_remapped.jsonl workload/
"""
import json
import re
import sys

from llm_multiseg_generation import _var_labels, _unknown_property, _signature, PROP_MAPPING

REMAP = {
    "Person": {"birthday": "creationDate", "browserUsed": "gender", "locationIP": "firstName",
               "email": "lastName", "speaks": "lastName"},
    "Message": {"browserUsed": "length", "locationIP": "content"},
}
REMAP["Post"] = REMAP["Comment"] = REMAP["Message"]


def remap(cypher: str):
    labels = _var_labels(cypher)
    changes = []

    def sub(m):
        var, prop = m.group(1), m.group(2)
        base = re.sub(r"\d+$", "", labels.get(var, ""))
        new = REMAP.get(base, {}).get(prop)
        if new:
            changes.append(f"{base}.{prop}->{new}")
            return f"{var}.{new}"
        return m.group(0)
    out = re.sub(r"\b([A-Za-z_]\w*)\.([A-Za-z_]\w*)\b", sub, cypher)
    return out, changes


def main(src, dst):
    seen, n_in, n_changed, n_out, dropped = set(), 0, 0, 0, []
    with open(dst, "w") as f:
        for line in open(src):
            rec = json.loads(line)
            n_in += 1
            new, changes = remap(rec["cypher"])
            if changes:
                n_changed += 1
                rec["property_remap"] = changes
                rec["cypher_before_remap"] = rec["cypher"]
                rec["cypher"] = new
            bad = _unknown_property(new, _var_labels(new))
            sig = _signature(new)
            if bad or sig in seen:
                dropped.append((n_in - 1, bad or "duplicate after remap"))
                continue
            seen.add(sig)
            f.write(json.dumps(rec) + "\n")
            n_out += 1
    print(f"{n_in} queries, {n_changed} remapped, {n_out} written, dropped {dropped}")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
