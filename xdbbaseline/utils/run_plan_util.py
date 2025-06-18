import logging
import time

from neo4j.exceptions import ClientError

from utils.neo4j_utils import Neo4jUtil
from utils.pg_utils import PostgresUtil, DataTooLargeError


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

    def run_table_movement_query(self, table_names_labels: list[(str, str, str)]):
        for table_real_name, label, cols in table_names_labels:
            properties = ", ".join([f"{col}: row.{col.lower()}" for col in cols])
            complete_query = f'''CALL apoc.periodic.iterate(
                    "CALL apoc.load.jdbc('jdbc:postgresql://localhost:5432/{self.pg_util.dbname}?user={self.pg_util.user}&password={self.pg_util.password}',
                    '\\"{table_real_name}\\"') YIELD row",
                    "CREATE (x:{label}T {{{properties}}})", 
                    {{batchSize: 5000, parallel: true}}
                );'''
            self.neo4j_util.run_query(complete_query)

    # def run_plan(self, table_labels: set[str], cypher_query: str, sql_query: str) -> float:
    def run_plan(self, cypher_query: str, cypher_count_query: str, sql_query: str) -> float:
        """
        :param cypher_count_query: count og the result
        :param table_move_query: a list of queries to move underlying tables to neo4j
        :param cypher_query: modified Cypher query with joins with tables passed to it
        :param sql_query: modified SQl query with Cypher query result and the rest of tables which are not passed to Neo4j
        :return: plan execution time
        """
        max_records = 1000000
        large_query_time = 10000
        out_of_time_query_time = 100000
        # move tables to neo4j
        # store the tables to Neo4j as Nodes
        # insert_table_start = time.time()
        # # this movement query should be constructed by the rewriter not here, here is just for running
        # self.run_table_movement_query(table_move_query)
        # insert_table_time = time.time() - insert_table_start
        # logging.info(f"Tables move to Neo4j cost: {insert_table_time} seconds")

        # run Cypher query
        # if all tables are stored to Neo4j, there is no need to store neo4j results, the whole thing returned by neo4j
        # will be the final results

        # neo4j_result = self.neo4j_util.run_query_stream(cypher_query)
        # cypher_query_end = time.time()
        # logging.info(f"Cypher query result size: {len(neo4j_result)}")
        # do not materialize all neo4j result, take each batch and insert
        # this will be the total of neo4j query cost + neo4j result move to pg cost

        try:
            result_size = self.neo4j_util.run_query_return_single_value(cypher_count_query)
            # if the count is None, still should execute the following queries; this is for fast filter out
            # the too large results
            if result_size is None:
                logging.info(f"Cypher count query can not return")
                return -1
            elif result_size > max_records:
                logging.info(f"Cypher query result size {result_size} is too large")
                return -1
            else:
                logging.info(f"Cypher query result size is {result_size}")
        # todo: for postgresql, set a time out
        except ClientError as e:
            logging.info("Count query timeout, the result size should be very large")
            return -1
        except Exception as e:
            logging.info(f"plan has error {e}")
            return -1

        store_neo4j_result_start = time.time()
        try:
            # optimizing this import
            # run cypher query and import the results to postgres by batch
            neo4j_result_size = self.neo4j_util.run_query_stream(cypher_query, self.pg_util, max_records=max_records)
        except DataTooLargeError:
            return -1
        except Exception as e:
            logging.info(e)
            return -1

        if neo4j_result_size == 0:
            return 0

        if sql_query is None:
            logging.info(f"The final result size is {neo4j_result_size}")
            return neo4j_result_size

        final_result = self.pg_util.run_query_return_result(sql_query)
        return len(final_result)

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
