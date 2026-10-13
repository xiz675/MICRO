"""
Restore the subset labels of CM-LDBC (Person1, Post2, Forum2, Comment2, Message2, ...) in a Neo4j graph that was
re-imported from the raw LDBC CSV files (which only have the base labels Person, Post, ...).

Source of truth: the filter tables of the XDB database (db1), which xdbbaseline/generate_tables.py created from
these very labels: table filter_<label><n> holds the ids of the nodes that carry label <Label><n>.

    # list what would be done (no writes)
    python restore_subset_labels.py --pg-host lero-postgres2-sf1 --pg-db postgres --pg-pw xw --nj-uri lero-neo4j-sf1:7687
    # do it
    python restore_subset_labels.py ... --apply
    # check
    python restore_subset_labels.py ... --verify

Labels are added with SET (idempotent): running it twice is harmless.
"""
import argparse
import re
import time

import psycopg2
from neo4j import GraphDatabase

BASE_LABELS = ["Person", "Post", "Comment", "Message", "Forum", "Tag", "TagClass", "Place", "City", "Country",
               "Continent", "Organisation", "University", "Company"]
BY_LOWER = {b.lower(): b for b in BASE_LABELS}


def label_of(table: str):
    """filter_comment2 -> (Comment, Comment2); None if the table is not a subset-label filter table"""
    m = re.fullmatch(r"filter_([a-z]+)(\d+)", table)
    if not m or m.group(1) not in BY_LOWER:
        return None
    base = BY_LOWER[m.group(1)]
    return base, f"{base}{m.group(2)}"


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--pg-host", required=True, help="PostgreSQL holding the filter_* tables (XDB db1)")
    ap.add_argument("--pg-db", default="postgres")
    ap.add_argument("--pg-user", default="postgres")
    ap.add_argument("--pg-pw", default="postgres")
    ap.add_argument("--pg-port", type=int, default=5432)
    ap.add_argument("--nj-uri", default="lero-neo4j-sf1:7687")
    ap.add_argument("--nj-user", default="neo4j")
    ap.add_argument("--nj-pw", default="neo4j")
    ap.add_argument("--nj-db", default="neo4j")
    ap.add_argument("--only", nargs="*", help="restore only these labels, e.g. Person1 Post2")
    ap.add_argument("--batch", type=int, default=50000)
    ap.add_argument("--apply", action="store_true", help="write the labels (default: only list)")
    ap.add_argument("--verify", action="store_true", help="compare label counts with the filter tables")
    args = ap.parse_args()

    pg = psycopg2.connect(host=args.pg_host, port=args.pg_port, dbname=args.pg_db, user=args.pg_user,
                          password=args.pg_pw)
    cur = pg.cursor()
    cur.execute("SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename LIKE 'filter\\_%'")
    jobs = []
    for (t,) in sorted(cur.fetchall()):
        lab = label_of(t)
        if lab and (not args.only or lab[1] in args.only):
            cur.execute(f"SELECT count(*) FROM {t}")
            jobs.append((t, lab[0], lab[1], cur.fetchone()[0]))
    if not jobs:
        raise SystemExit("no filter_<label><n> tables found: is --pg-host/--pg-db the XDB graph database (db1)?")

    drv = GraphDatabase.driver(f"bolt://{args.nj_uri}", auth=(args.nj_user, args.nj_pw))
    with drv.session(database=args.nj_db) as s:
        for t, base, label, n in jobs:
            have = s.run(f"MATCH (n:{label}) RETURN count(n) AS c").single()["c"]
            print(f"{t:22s} -> :{label:12s} filter rows {n:>10,}   nodes with label now {have:>10,}")
        if args.verify or not args.apply:
            if not args.apply:
                print("\n(list only; add --apply to write the labels)")
            return

        for t, base, label, n in jobs:
            # index on the base label's id makes the MATCH below a lookup (create-indices.sh normally creates it)
            s.run(f"CREATE INDEX IF NOT EXISTS FOR (n:{base}) ON (n.id)").consume()
            start, done = time.time(), 0
            with pg.cursor(name=f"c_{t}") as c:          # server-side cursor: stream ids
                c.itersize = args.batch
                c.execute(f"SELECT id FROM {t}")
                while True:
                    rows = c.fetchmany(args.batch)
                    if not rows:
                        break
                    ids = [r[0] for r in rows]
                    s.run(f"UNWIND $ids AS i MATCH (n:{base} {{id: i}}) SET n:{label}", ids=ids).consume()
                    done += len(ids)
            have = s.run(f"MATCH (n:{label}) RETURN count(n) AS c").single()["c"]
            flag = "" if have == n else "   <-- MISMATCH (ids missing in the graph?)"
            print(f":{label:12s} {done:>10,} ids processed, {have:>10,} nodes labelled, "
                  f"{time.time() - start:.0f}s{flag}")
    drv.close()


if __name__ == "__main__":
    main()
