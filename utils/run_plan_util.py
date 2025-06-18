import logging
import time

from neo4j.exceptions import ClientError

from utils.neo4j_utils import Neo4jUtil
from utils.pg_utils import PostgresUtil, DataTooLargeError

MAX_RECORDS = 10000000
LARGE_QUERY_TIME = 10000
OUT_OF_TIME_QUERY_TIME = 100000


class RunPlan:
    def __init__(self, pg_util: PostgresUtil, neo4j_util: Neo4jUtil):
        """

        :param pg_util:
        :param neo4j_util:
        # :param label_2_table_dict: a dictionary of table label to the underlying real table name, this is for moving
        # real tables to neo4j
        """
        self.pg_util = pg_util
        self.neo4j_util = neo4j_util
        # self.label_2_table_dict = label_2_table_dict

    def run_table_movement_query(self, table_names_labels: list[(str, str, set)]):
        for table_real_name, label, cols in table_names_labels:
            properties = ", ".join([f"{col}: row.{col.lower()}" for col in cols])
            complete_query = f'''CALL apoc.periodic.iterate(
                    "CALL apoc.load.jdbc('jdbc:postgresql://{self.pg_util.hostname}:5432/{self.pg_util.dbname}?user={self.pg_util.user}&password={self.pg_util.password}',
                    '{table_real_name}') YIELD row",
                    "CREATE (x:{label}T {{{properties}}})", 
                    {{batchSize: 20000, parallel: true}}
                );'''
            # print(complete_query)
            self.neo4j_util.run_query(complete_query)

    # def run_plan(self, table_labels: set[str], cypher_query: str, sql_query: str) -> float:
    def run_plan(self, table_move_query: list[(str, str, set)], cypher_query: str, cypher_count_query: str,
                 sql_query: str, no_max_record=False) -> float:
        """
        :param no_max_record:
        :param cypher_count_query: count of the result
        :param table_move_query: a list of queries to move underlying tables to neo4j
        :param cypher_query: modified Cypher query with joins with tables passed to it
        :param sql_query: modified SQl query with Cypher query result and the rest of tables which are not passed to Neo4j
        :return: plan execution time
        """
        if no_max_record:
            max_rec = 10000000
        else:
            max_rec = MAX_RECORDS
        # move tables to neo4j
        # store the tables to Neo4j as Nodes
        insert_table_start = time.time()
        # this movement query should be constructed by the rewriter not here, here is just for running
        self.run_table_movement_query(table_move_query)
        insert_table_time = time.time() - insert_table_start
        logging.info(f"Tables move to Neo4j cost: {insert_table_time} seconds")

        # run Cypher query
        # if all tables are stored to Neo4j, there is no need to store neo4j results, the whole thing returned by neo4j
        # will be the final results

        # neo4j_result = self.neo4j_util.run_query_stream(cypher_query)
        # cypher_query_end = time.time()
        # logging.info(f"Cypher query result size: {len(neo4j_result)}")
        # do not materialize all neo4j result, take each batch and insert
        # this will be the total of neo4j query cost + neo4j result move to pg cost
        if not no_max_record:
            try:
                result_size = self.neo4j_util.run_query_return_single_value(cypher_count_query)
                # if the count is None, still should execute the following queries; this is for fast filter out
                # the too large results
                if result_size is None:
                    logging.info(f"Cypher count query can not return")
                    return OUT_OF_TIME_QUERY_TIME
                elif result_size > max_rec:
                    logging.info(f"Cypher query result size {result_size} is too large")
                    return LARGE_QUERY_TIME
                else:
                    logging.info(f"Cypher query result size is {result_size}")
            # todo: for postgresql, set a time out
            except ClientError as e:
                logging.info("Count query timeout, the result size should be very large")
                return OUT_OF_TIME_QUERY_TIME
            except Exception as e:
                logging.info(f"plan has error {e}")
                return OUT_OF_TIME_QUERY_TIME

        store_neo4j_result_start = time.time()
        try:
            # optimizing this import
            # run cypher query and import the results to postgres by batch
            if sql_query is None:
                neo4j_result_size = self.neo4j_util.run_query_return_size(cypher_query)
            else:
                neo4j_result_size = self.neo4j_util.run_query_stream(cypher_query, self.pg_util, max_records=max_rec)
        except DataTooLargeError:
            logging.info(
                f"Run Cypher query + store Cypher query result cost: {time.time() - store_neo4j_result_start} seconds")
            logging.info("Cypher query result size is too large")
            return LARGE_QUERY_TIME
        except Exception as e:
            logging.info(e)
            return LARGE_QUERY_TIME
        # self.pg_util.insert_neo4j_results(neo4j_result, "neo4j")
        store_neo4j_result_time = time.time() - store_neo4j_result_start
        logging.info(f"After running Cypher query: the Cypher result size is {neo4j_result_size}")
        logging.info(
            f"Run Cypher query + store Cypher query result cost: {store_neo4j_result_time} seconds")

        total_time_wo_sql = insert_table_time + store_neo4j_result_time

        if neo4j_result_size == 0:
            logging.info(f"Total runtime is {total_time_wo_sql}")
            return total_time_wo_sql

        if sql_query is None:
            logging.info(f"The final result size is {neo4j_result_size}")
            logging.info(f"Total runtime is {total_time_wo_sql}")
            return total_time_wo_sql

        sql_start = time.time()
        final_result = self.pg_util.run_query_return_result(sql_query)
        sql_query_time = time.time() - sql_start

        logging.info(f"Run the SQL query cost: {sql_query_time}")
        logging.info(f"The final result size is {len(final_result)}")
        total_time = total_time_wo_sql + sql_query_time
        logging.info(f"Total runtime is {total_time}")
        return total_time

    def clean_data(self, labels: set[str]):
        # deleting table nodes from neo4j
        # labels = "".join([f":{table}T" for table in tables])
        for label in labels:
            delete_cypher = f'''CALL apoc.periodic.iterate(
                'MATCH (n:{label}T) RETURN n', 
                'DELETE n',
                {{ batchSize: 1000, parallel: true }})'''
            # print(delete_cypher)
            self.neo4j_util.run_query(delete_cypher)
        # deleting Neo4j result from pg
        self.pg_util.run_query('''DROP TABLE IF EXISTS "neo4j"''')
