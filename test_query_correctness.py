import argparse
import os
import re

from utils.cypher_parser_util import CypherParser
from utils.neo4j_utils import Neo4jUtil
from utils.pg_utils import PostgresUtil
from utils.rewriter_util import CrossRewriter
from utils.run_plan_util import RunPlan
from utils.sql_parser_util import SQLParser

table_dict = {"Organisation": "r_organisation",
              "Place": "r_place",
              "Tag": "r_tag",
              "TagClass": "r_tagclass",
              "Comment": "r_comment",
              "Forum": "r_forum",
              "Person": "r_person",
              "Post": "r_post",
              "Message": "r_message",
              "Country": "r_country",
              "City": "r_city",
              "Company": "r_company",
              "University": "r_university"
              }


def get_sql_result_count(sql_query: str, pg_util: PostgresUtil):
    return len(pg_util.run_query_return_result(sql_query))


class InvalidQueryError(Exception):
    pass


def get_cross_query_result_count(cm_query: str, plan_executor: RunPlan):
    q_pairs = cm_query.strip().split('**********')
    if len(q_pairs) != 2:
        print(q_pairs)
        raise InvalidQueryError("query should have two parts")
    cypher_query, sql_query = q_pairs[0].strip(), q_pairs[1].strip()
    sql_info = SQLParser(sql_query).parser()
    cypher_info = CypherParser(cypher_query, sql_info.select_mapping['neo4j']).parser()
    cr = CrossRewriter(sql_info, cypher_info, table_dict)
    rewritten_cypher, rewritten_cypher_count, rewritten_sql = cr.rewrite()
    return plan_executor.run_plan(rewritten_cypher, rewritten_cypher_count, rewritten_sql)


def read_cm_queries(f: str):
    with open(f, 'r') as file:
        queries = file.read()
    return [i.strip() for i in queries.split("##########") if i != ""]


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
    # Add arguments for Neo4j
    parser.add_argument('--nj-uri', dest='nj_uri', default='bolt://localhost:7687', type=str, help='Neo4j database URI')
    parser.add_argument('--nj-db', dest='nj_db', default='neo4j', type=str, help='Neo4j database name')
    parser.add_argument('--nj-user', dest='nj_user', default='neo4j', type=str, help='Neo4j user name')
    parser.add_argument('--nj-pw', dest='nj_pw', default='neo4j', type=str, help='Neo4j password')

    # Add arguments for PostgreSQL
    parser.add_argument('--pg-host', dest='pg_host', default='localhost', type=str, help='PostgreSQL database host')
    parser.add_argument('--pg-db', dest='pg_db', default='postgres', type=str, help='PostgreSQL database name')
    parser.add_argument('--pg-user', dest='pg_user', default='postgres', type=str, help='PostgreSQL user name')
    parser.add_argument('--pg-pw', dest='pg_pw', default='postgres', type=str, help='PostgreSQL password')

    # Add arguments for storing results
    parser.add_argument('--result-path', dest='result_path', type=str, default='.')

    return parser.parse_args()


# after splitting sql queries to test and train set, split the corresponding cross model queries accordingly
if __name__ == '__main__':
    # cross_model_query_path = r'C:\Users\sauzh\Documents\Work\crossmodel\workloads\gpt-wo-agg-new\cross-model-query'
    args = parse_arguments()
    result_path = args.result_path
    query_path = args.query_path
    # cross_model_splitted_query_path = r'C:\Users\sauzh\Documents\Work\crossmodel\workloads\gpt-wo-agg-new\cross-model-query-splitted'
    # train_idx, test_idx = (get_idx_dict(os.path.join(sql_query_index_path, 'train_index.txt')),
    #                        get_idx_dict(os.path.join(sql_query_index_path, 'test_index.txt')))
    # cm_queries = read_all_queries(cross_model_query_path)
    # train_queries, test_queries = split_cross_model_query(train_idx, test_idx, cm_queries)
    # Path(os.path.join(cross_model_splitted_query_path, "train.txt")).write_text("\n".join(train_queries))
    # Path(os.path.join(cross_model_splitted_query_path, "test.txt")).write_text("\n".join(test_queries))

    # run the cm test queries, get the count and run the sql queries get the count
    cm_queries = read_cm_queries(os.path.join(query_path, 'test.txt'))
    sql_queries = read_sql_queries(os.path.join(query_path, 'test.sql'))

    neo4j_util = Neo4jUtil(args.nj_uri, args.nj_user, args.nj_pw, args.nj_db)
    db_util = PostgresUtil(args.pg_db, args.pg_user, args.pg_pw, args.pg_host)
    db_util.connect()
    executor = RunPlan(db_util, neo4j_util)
    # run the queries to get the count
    assert len(cm_queries) == len(sql_queries)
    cm_count = []
    sql_count = []
    for i in range(len(cm_queries)):
        sql_q = sql_queries[i]
        if 'TODO' in sql_q:
            continue
        cm_q = cm_queries[i]
        executor.clean_data(set())
        crt_sql_ct = get_sql_result_count(sql_q, db_util)
        crt_cm_ct = get_cross_query_result_count(cm_q, executor)
        print(f"sql query {i} count: {crt_sql_ct}")
        print(f"cm query {i} count: {crt_cm_ct}")
        sql_count.append(crt_sql_ct)
        cm_count.append(crt_cm_ct)
    with (open(f"{result_path}/sql_count.txt", 'w') as file):
        file.writelines(f"{num}\n" for num in sql_count)
    with (open(f"{result_path}/cm_count.txt", 'w') as file):
        file.writelines(f"{num}\n" for num in cm_count)
