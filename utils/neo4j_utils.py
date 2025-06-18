import csv
import json
import logging
import time
from io import StringIO

import pandas as pd
from neo4j import GraphDatabase
from neo4j.exceptions import ClientError
from pandas import DataFrame

from utils.pg_utils import PostgresUtil, DataTooLargeError


class Neo4jUtil:
    def __init__(self, uri, user, password, database):
        self._driver = GraphDatabase.driver(uri, auth=(user, password), database=database)

    def close(self):
        self._driver.close()

    def explain_query_plan(self, query):
        plan = self._driver.execute_query(f"EXPLAIN {query}").summary.plan
        json_plan = json.dumps(plan, indent=2)
        return json_plan

    def run_query_return_df(self, query, timeout_seconds=3000) -> DataFrame | None:
        try:
            # Wrap the query with apoc.cypher.runTimeboxed for the specified timeout
            timeout_query = f"""
            CALL apoc.cypher.runTimeboxed(
                \"{query}\", {{}}, {timeout_seconds}) 
            YIELD value 
            RETURN value
            """
            # Execute the query and convert the result to a DataFrame
            with self._driver.session() as session:
                result = session.run(timeout_query)
                # Convert result to a DataFrame
                records = [record["value"] for record in result]
                if records:
                    return pd.DataFrame(records)
                else:
                    return None  # Return an empty DataFrame if there are no results

        except Exception as e:
            logging.error(f"Error executing the query: {e}")
            return None  # Return an empty DataFrame on error

        # try:
        #     with self._driver.session() as session:
        #         result = session.run(query)
        #         return result.to_df()
        # except Exception as e:
        #     logging.error(f"Error executing the query: {e}")

    def run_query_stream(self, query, pg_util: PostgresUtil, batch_size=50*1024*1024, max_records=10000000):
        """Stream results from Neo4j and process them in batches."""
        try:
            with self._driver.session() as session:
                start_time = time.time()
                result = session.run(query)
                # this is the query runtime without transfer any data
                logging.info(f"---Sub: Cypher query cost: {time.time() - start_time} seconds")
                is_table_created = False
                total_rows = 0
                # create table
                table_name = "neo4j"

                peek_record = result.peek()
                if peek_record is None:
                    return 0

                cols = peek_record.keys()
                dtypes = [type(peek_record[col]).__name__ for col in cols]
                pg_util.run_query(pg_util.create_pg_table(table_name, cols, dtypes))
                # prepare copy sql
                copy_sql = f"COPY {table_name} ({', '.join(cols)}) FROM STDIN WITH CSV"

                # transfer neo4j result to buffered csv and then import it to postgres
                csv_buffer = StringIO()
                csv_writer = csv.writer(csv_buffer)

                csv_writer.writerow([peek_record[col] for col in cols])
                num_rows_in_buffer = 1

                for record in result:
                    csv_writer.writerow([record[col] for col in cols])
                    num_rows_in_buffer += 1
                    if csv_buffer.tell() > batch_size:
                        total_rows += num_rows_in_buffer
                        if total_rows > max_records:
                            raise DataTooLargeError(f"Data is too large to store as a table: exceeds {max_records}")
                        # reset the pointer
                        csv_buffer.seek(0)
                        pg_util.cursor.copy_expert(copy_sql, csv_buffer)
                        # clear the buffer and reset the pointer
                        csv_buffer.truncate(0)
                        csv_buffer.seek(0)
                        # print(f"Inserted {num_rows_in_buffer} rows into {table_name}, Total so far: {total_rows}")
                        num_rows_in_buffer = 0

                # flush the remaining data
                csv_buffer.seek(0)
                pg_util.cursor.copy_expert(copy_sql, csv_buffer)
                total_rows += num_rows_in_buffer
                # print(f"Total rows inserted: {total_rows}")
                return total_rows
                # batch = []
                # for record in result:
                #     batch.append(record)
                #     if len(batch) >= batch_size:
                #         yield pd.DataFrame(batch, columns=record.keys())  # Yield a batch as a DataFrame
                #         batch.clear()  # Reset the batch list
                # if batch:
                #     yield pd.DataFrame(batch, columns=record.keys())  # Yield any remaining records
        except Exception as e:
            logging.error(f"Error executing the query: {e}")

    def run_query(self, query):
        with self._driver.session() as session:
            session.run(query)

    def run_query_return_size(self, query):
        with self._driver.session() as session:
            result = session.run(query)
            return len(list(result))

    def run_query_return_single_value(self, query):
        with self._driver.session() as session:
            try:
                result = session.run(query)
                single_value = result.single()
                if single_value:
                    count_value = single_value["value"].get("count(*)")
                    return float(count_value) if count_value is not None else None
                return None
            except ClientError as e:
                print(str(e))
                raise e
            except Exception as e:
                raise e

    # return the output cardinality
    def verify_correctness(self, query):
        plan = self._driver.execute_query(f"EXPLAIN {query}").summary.plan
        return plan["args"]["EstimatedRows"]
