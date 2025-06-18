import json
import logging

import pandas
from neo4j import GraphDatabase


class Neo4jUtil:
    def __init__(self, uri, user, password, database):
        self._driver = GraphDatabase.driver(uri, auth=(user, password), database=database)

    def close(self):
        self._driver.close()

    def explain_query_plan(self, query):
        plan = self._driver.execute_query(f"EXPLAIN {query}").summary.plan
        json_plan = json.dumps(plan, indent=2)
        return json_plan

    def run_query_return_df(self, query) -> pandas.DataFrame:
        try:
            with self._driver.session() as session:
                result = session.run(query)
                return result.to_df()
        except Exception as e:
            logging.error(f"Error executing the query: {e}")

    def run_query(self, query):
        with self._driver.session() as session:
            session.run(query)

    # return the output cardinality
    def verify_correctness(self, query):
        plan = self._driver.execute_query(f"EXPLAIN {query}").summary.plan
        return plan["args"]["EstimatedRows"]
