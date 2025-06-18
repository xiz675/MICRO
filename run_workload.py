# given a workload with its all plans, run each of them and store the runtime
import argparse
import logging

from utils.store_and_load_training_data_for_lero import store_json_list, store_all_plans
from utils.cypher_parser_util import CypherParser, get_query_wo_predicates
from utils.neo4j_utils import Neo4jUtil
from utils.pg_utils import PostgresUtil
from utils.rewriter_util import generate_plans, CrossRewriter
from utils.run_plan_util import RunPlan, LARGE_QUERY_TIME
from utils.sql_parser_util import SQLParser

# this is one table dict for sf10
# todo: choose different combinations
label_table_dict = {
              "Organisation": "r_organisation",
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

# table_label_dict = {
#         "uspto.inventors": "Author",
#         "uspto.institution":  "Institution",
#         "uspto.topic_patent":  "Topic",
#         "uspto.subfield_patent": "Subfield",
#         "uspto.field_patent": "Field",
#         "uspto.publication_cited_by_patent": "Work"
# }


def parse_arguments():
    # Create the parser
    parser = argparse.ArgumentParser(description='Process command line arguments.')

    # Add arguments for table dictionary and query directory
    # parser.add_argument('--tables-dict', dest='table_dict_name', type=str, help='Name of the table dictionary', required=True)
    parser.add_argument('--query-path', dest='query_path', type=str, help='Path to directory containing queries',
                        required=True)
    parser.add_argument('--log-file', dest='log_file', default='test', type=str)
    # Add arguments for Neo4j
    parser.add_argument('--nj-uri', dest='nj_uri', default='localhost', type=str, help='Neo4j database URI')
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


if __name__ == '__main__':
    # Parse the command line arguments
    args = parse_arguments()
    query_path = args.query_path
    log_file = args.log_file
    # table_dict_name = args.table_dict_name

    # Configure logging to use the specified log file name
    logging.basicConfig(filename=log_file, level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

    # connect to neo4j database to check if the modified queries and plans are correct
    # neo4j_util = Neo4jUtil(f'''bolt://{args.nj_uri}:7687''', args.nj_user, args.nj_pw, args.nj_db)
    neo4j_util = Neo4jUtil(f'''bolt://{args.nj_uri}''', args.nj_user, args.nj_pw, args.nj_db)
    # connect to pg database
    db_util = PostgresUtil(args.pg_db, args.pg_user, args.pg_pw, args.pg_host)
    db_util.connect()
    result_path = args.result_path
    executor = RunPlan(db_util, neo4j_util)

    # read all the cross queries in the query file
    with open(query_path, 'r') as file:
        # Read the entire file content
        all_queries = file.read()

    # Split the queries by the delimiter '##########', and by '**********' to get sql and cypher
    all_queries_list = []
    for qs in all_queries.split('##########'):
        q_pairs = qs.strip().split('**********')
        if len(q_pairs) != 2:
            print(q_pairs)
            continue
        all_queries_list.append((q_pairs[0].strip(), q_pairs[1].strip()))

    # store raw neo4j plans for all workloads
    neo4j_raw_plans = []
    all_run_times = []
    all_workloads = []
    all_rewritten_plans = []
    for i in range(len(all_queries_list)):
        crt_workload_runtime = []
        cypher_query, sql_query = all_queries_list[i]
        logging.info(f'============= Start query {i} =============')
        # for each sql, cypher pair, get the parsed info, and then generate plans
        sql_info = SQLParser(sql_query).parser()
        cypher_info = CypherParser(cypher_query, sql_info.select_mapping['neo4j']).parser()

        # generate all plans for the workload
        where_stmts = sql_info.join_condition
        all_plans = generate_plans(where_stmts)

        # get the cypher query explain json
        try:
            neo4j_raw_plans.append(neo4j_util.explain_query_plan(get_query_wo_predicates(cypher_info)))
        except Exception as e:
            print(f"query {i} has error, skip")
            print(e)
            continue
        plan_num = 0
        crt_rewritten_plans = []
        crt_best_time = LARGE_QUERY_TIME
        for crt_plan in all_plans:
            logging.info(f'============= Start plan {plan_num} =============')
            plan_num += 1
            cr = CrossRewriter(sql_info, cypher_info)
            # cr = CrossRewriter(sql_info, cypher_info, label_2_table_dict=label_table_dict)
            # the plan is [(neo4j_var.prop, table_var.col, label(neo4j var and table's corresponding label), ...]
            try:
                rewritten_plan, table_move_cypher, rewritten_cypher, rewritten_cypher_count, rewritten_sql = cr.rewrite(crt_plan)
            except Exception as e:
                logging.error(f"Rewriter error: {e}")
                crt_workload_runtime.append(0)
                continue

            crt_rewritten_plans.append(rewritten_plan)

            if len(crt_plan) == len(where_stmts):
                rewritten_sql = None
                all_workloads.append(rewritten_plan)
            moved_table_labels = set([i[-1] for i in rewritten_plan])
            executor.clean_data(moved_table_labels)
            logging.info(f"Tables moved to neo4j: {', '.join(moved_table_labels)}")

            # if the estimated size is larger than a threshold, then skip the first baseline plan
            # if plan_num == 1 and baseline_skip:
            #     crt_workload_runtime.append(1000000)
            #     continue

            # run plan and get runtime
            try:
                # for running plan, need to know what tables (labels) to move to neo4j, and from the mapping,
                #  we can get the real name of the table
                if plan_num == len(all_plans) and crt_best_time == LARGE_QUERY_TIME:
                    run_time = executor.run_plan(table_move_cypher, rewritten_cypher, rewritten_cypher_count,
                                                 rewritten_sql, True)
                else:
                    run_time = executor.run_plan(table_move_cypher, rewritten_cypher, rewritten_cypher_count,
                                                 rewritten_sql)
                # for storing the plan and runtime, need to have a list of tuples, each tuple is the neo4j's
                #  var.prop and table(var).col and their label
                crt_workload_runtime.append(run_time)
                crt_best_time = min(crt_best_time, run_time)
            except Exception as e:
                logging.error(f"Query run error: {e}")
                crt_workload_runtime.append(0)
            finally:
                executor.clean_data(moved_table_labels)
        logging.info(f'============= Done with all plans for query {i}! =============')
        all_run_times.append(crt_workload_runtime)
        all_rewritten_plans.append(crt_rewritten_plans)
        # all_plans.append(cr)
    logging.info(f'============= Done with all queries in file {query_path}! =============')
    store_json_list(f'{result_path}/cypher_raw_plans.json', neo4j_raw_plans)
    store_json_list(f'{result_path}/workloads.json', all_workloads)
    store_all_plans(f'{result_path}/all_plans_with_runtime.json', all_run_times, all_rewritten_plans)
    logging.info('Done!')
