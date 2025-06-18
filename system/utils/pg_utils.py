import concurrent.futures
import csv
import logging
from io import StringIO

import numpy as np
import psycopg2
from pandas import DataFrame, Series
from psycopg2 import OperationalError
import sys

class DataTooLargeError(Exception):
    """The Neo4j query size is too large to be stored as a table."""
    pass


def pandas_type_to_postgres_type(pandas_type: np.dtype):
    if np.issubdtype(pandas_type, np.integer):
        return 'BIGINT'
    elif np.issubdtype(pandas_type, np.floating):
        return 'DOUBLE PRECISION'
    elif np.issubdtype(pandas_type, np.bool_):
        return 'BOOLEAN'
    # Add more mappings as needed
    else:
        return 'TEXT'


PYTHON_TO_POSTGRES = {
    "int": "BIGINT",
    "float": "REAL",
    "str": "TEXT",
    "bool": "BOOLEAN",
    "NoneType": "TEXT",  # Default for NULL values
    "list": "TEXT",  # Consider JSONB if needed
    "dict": "TEXT",  # Consider JSONB if needed
    "DateTime": "timestamp with time zone"
}

class PostgresUtil:
    def __init__(self, dbname, user, password, host):
        self.dbname = dbname
        self.user = user
        self.password = password
        self.hostname = host
        self.con = None
        self.cursor = None

    @staticmethod
    def show_psycopg2_exception(err):
        # get details about the exception
        err_type, err_obj, traceback = sys.exc_info()
        # get the line number when exception occur
        line_n = traceback.tb_lineno
        # print the connect() error
        print("\npsycopg2 ERROR:", err, "on line number:", line_n)
        print("psycopg2 traceback:", traceback, "-- type:", err_type)
        # psycopg2 extensions.Diagnostics object attribute
        print("\nextensions.Diagnostics:", err.diag)
        # print the pgcode and pgerror exceptions
        print("pgerror:", err.pgerror)
        print("pgcode:", err.pgcode, "\n")

    def connect(self):
        try:
            self.con = psycopg2.connect(
                database=self.dbname, user=self.user, password=self.password, host=self.hostname
            )
            self.con.autocommit = True
            self.cursor = self.con.cursor()
            print("Connected to the database.")
        except OperationalError as err:
            self.show_psycopg2_exception(err)

    def disconnect(self):
        try:
            if self.cursor:
                self.cursor.close()
            if self.con:
                self.con.close()
            print("Disconnected from the database.")
        except Exception as e:
            print(f"Error: Unable to disconnect from the database - {e}")

    def run_query(self, query):
        try:
            self.cursor.execute(query)
            self.con.commit()
        except Exception as e:
            print(query)
            logging.error(f"Error: Unable to execute the query - {e}")
            self.con.rollback()

    def run_query_return_result(self, query) -> list:
        try:
            self.cursor.execute(query)
            result = self.cursor.fetchall()
            self.con.commit()
            return result
        except Exception as e:
            print(query)
            print(f"Error: Unable to execute the query and get result - {e}")
            self.con.rollback()

    def copy_from_pd(self, csv_data: StringIO, table_name, sep):
        try:
            self.cursor.copy_from(csv_data, table_name, sep=sep)
            self.con.commit()
        except Exception as e:
            print(f"Error: Unable to copy the data - {e}")
            self.con.rollback()

    def get_all_tables(self):
        # Get a list of all tables in the specified schema
        query = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'"
        return [table[0] for table in self.run_query_return_result(query)]

    def table_exist(self, table_name: str):
        # check if table exists
        return self.run_query_return_result(f"SELECT EXISTS (SELECT 1 FROM information_schema.tables "
                                            f"WHERE table_name = '{table_name}')")[0][0]

    def drop_table(self, table: str):
        drop_query = f'''DROP TABLE IF EXISTS "{table}"'''
        self.cursor.execute(drop_query)
        self.con.commit()
        print(f"Table {table} dropped")

    @staticmethod
    def create_pg_table(table_name, columns, data_types: list):
        # Infer the column types
        column_types = [PYTHON_TO_POSTGRES.get(i, 'Text') for i in data_types]
        # Generate a CREATE TABLE statement with the inferred types
        column_definitions = ", ".join(
            "%s %s" % (column, column_type)
            for column, column_type in zip(columns, column_types)
        )
        return f'''CREATE TABLE "{table_name}" ({column_definitions})'''

    def insert_neo4j_results(self, cypher_query_result: DataFrame, table_name: str):
        """create a table to store neo4j results"""
        # drop table if exists
        drop_statement = f'''DROP TABLE IF EXISTS "{table_name}"'''
        self.run_query(drop_statement)
        if len(cypher_query_result) == 0:
            return
        self.run_query(self.create_pg_table("neo4j", cypher_query_result.columns, cypher_query_result.dtypes.tolist()))
        # Insert data by storing to csv file and copy_from
        buffer = StringIO()
        cypher_query_result.to_csv(buffer, index=False, header=False, sep="|")
        buffer.seek(0)
        self.copy_from_pd(buffer, table_name, "|")
        # count = self.run_query_return_result(f'''select count(*) from "{table_name}" ''')[0]
        print(f"Neo4j result size is {len(cypher_query_result)}")

    # def insert_neo4j_stream_results(self, neo4j_util: Neo4jUtil, cypher_query, batch_size=10000, max_records=500000):
    #     # return cypher query size
    #     is_table_created = False
    #     total_rows = 0
    #     # create table
    #     table_name = "neo4j"
    #
    #     # transfer neo4j result to buffered csv and then import it to postgres
    #     csv_buffer = StringIO()
    #     csv_writer = csv.writer(csv_buffer)
    #     num_rows_in_buffer = 0
    #     cypher_result = neo4j_util.run_query_stream(cypher_query)
    #
    #     for record in cypher_result:
    #         if not is_table_created:
    #             # get cols and dtypes
    #             cols = record.keys()
    #             dtypes = [type(record[col].__name__ for col in cols)]
    #             self.run_query(self.create_pg_table(table_name, cols, dtypes))
    #             # prepare copy sql
    #             copy_sql = f"COPY {table_name} ({', '.join(cols)}) FROM STDIN WITH CSV"
    #             is_table_created = True
    #         csv_writer.writerow([record[col] for col in cols])
    #         num_rows_in_buffer += 1
    #         if csv_buffer.tell() > batch_size:
    #             total_rows += num_rows_in_buffer
    #             if total_rows > max_records:
    #                 raise DataTooLargeError(f"Data is too large to store as a table: exceeds {max_records}")
    #             # reset the pointer
    #             csv_buffer.seek(0)
    #             self.cursor.copy_expert(copy_sql, csv_buffer)
    #             # clear the buffer and reset the pointer
    #             csv_buffer.truncate(0)
    #             csv_buffer.seek(0)
    #             print(f"Inserted {num_rows_in_buffer} rows into {table_name}, Total so far: {total_rows}")
    #             num_rows_in_buffer = 0
    #
    #     # flush the remaining data
    #     csv_buffer.seek(0)
    #     self.cursor.copy_expert(copy_sql, csv_buffer)
    #     total_rows += num_rows_in_buffer
    #     print(f"Total rows inserted: {total_rows}")
    #     # for batch_df in , batch_size):
    #     #     if not is_table_created:
    #     #         # Create the table for the first batch
    #     #         self.run_query(self.create_pg_table("neo4j", batch_df.columns, batch_df.dtypes))
    #     #         is_table_created = True
    #     #
    #     #     # Insert the batch into PostgreSQL
    #     #     buffer = StringIO()
    #     #     batch_df.to_csv(buffer, index=False, header=False, sep="|")
    #     #     buffer.seek(0)
    #     #     self.copy_from_pd(buffer, table_name, "|")
    #     #
    #     #     total_rows += len(batch_df)
    #     #     # todo: modify the maximum record num when do the real experiment
    #     #     if total_rows > max_records:
    #     #         raise DataTooLargeError(f"Data is too large to store as a table: exceeds {max_records}")
    #     #
    #     #     print(f"Inserted {len(batch_df)} rows into {table_name}, Total so far: {total_rows}")
    #     # print(f"Total rows inserted: {total_rows}")
    #     return total_rows

    # def run_insert_neo4j_stream_with_timeout(self, neo4j_util: Neo4jUtil, cypher_query, table_name: str, batch_size=10000, timeout=300):
    #     with concurrent.futures.ProcessPoolExecutor() as executor:
    #         future = executor.submit(self.insert_neo4j_stream_results, neo4j_util, cypher_query, table_name, batch_size)
    #     try:
    #         result = future.result(timeout=timeout)
    #         return result
    #     except concurrent.futures.TimeoutError:
    #         future.cancel()
    #         raise DataTooLargeError(f"Data is too large to store as a table")
