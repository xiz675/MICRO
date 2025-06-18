import argparse
import os
import time

from utils.pg_utils import PostgresUtil


def read_sql_queries(f: str):
    with open(f, 'r') as file:
        queries = file.read()
    return [i.strip() for i in queries.split(";\n") if i != ""]


def parse_arguments():
    # Create the parser
    parser = argparse.ArgumentParser(description='Process command line arguments.')

    # Add arguments for table dictionary and query directory
    # parser.add_argument('--tables-dict', dest='table_dict_name', type=str, help='Name of the table dictionary', required=True)
    parser.add_argument('--query-path', dest='query_path', type=str,
                        help='Path to directory containing sql and cm queries',
                        required=True)

    # Add arguments for PostgreSQL
    parser.add_argument('--pg-host', dest='pg_host', default='localhost', type=str, help='PostgreSQL database host')
    parser.add_argument('--pg-db', dest='pg_db', default='postgres', type=str, help='PostgreSQL database name')
    parser.add_argument('--pg-user', dest='pg_user', default='postgres', type=str, help='PostgreSQL user name')
    parser.add_argument('--pg-pw', dest='pg_pw', default='postgres', type=str, help='PostgreSQL password')

    # Add arguments for storing results
    parser.add_argument('--result-path', dest='result_path', type=str, default='.')

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_arguments()
    result_path = args.result_path
    query_path = args.query_path
    sql_queries = read_sql_queries(os.path.join(query_path, 'all_test.sql'))
    start_time = time.time()
    # sql_queries = read_sql_queries(query_path)
    db_util = PostgresUtil(args.pg_db, args.pg_user, args.pg_pw, args.pg_host)
    db_util.connect()

    db_util.run_query("SET search_path TO openalex_subset;")
    counts = []
    times = []
    for q in sql_queries:
        st = time.time()
        if 'TODO' in q:
            continue
        result = db_util.run_query_return_result(q)
        counts.append(len(result))
        et = time.time()
        times.append(et-st)
    end_time = time.time()
    print(f"The total runtime for all queries is {end_time - start_time}")
    with (open(f"{result_path}/sql_count.txt", 'w') as file):
        file.writelines(f"{num}\n" for num in counts)
    with (open(f"{result_path}/times.txt", 'w') as file):
        file.writelines(f"{t}\n" for t in times)
