from io import StringIO

import numpy as np
import psycopg2
from pandas import DataFrame
from psycopg2 import OperationalError
import sys


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
            print(f"Error: Unable to execute the query - {e}")
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

    def insert_neo4j_results(self, cypher_query_result: DataFrame, table_name: str):
        """create a table to store neo4j results"""
        # drop table if exists
        drop_statement = f'''DROP TABLE IF EXISTS "{table_name}"'''
        self.run_query(drop_statement)
        if len(cypher_query_result) == 0:
            return
        columns = cypher_query_result.columns
        # Infer the column types
        column_types = [pandas_type_to_postgres_type(cypher_query_result.dtypes[i]) for i in columns]
        # Generate a CREATE TABLE statement with the inferred types
        column_definitions = ", ".join(
            "%s %s" % (column, column_type)
            for column, column_type in zip(columns, column_types)
        )
        create_table_statement = f'''CREATE TABLE "{table_name}" ({column_definitions})'''
        self.run_query(create_table_statement)
        # Insert data by storing to csv file and copy_from
        buffer = StringIO()
        cypher_query_result.to_csv(buffer, index=False, header=False, sep="|")
        buffer.seek(0)
        self.copy_from_pd(buffer, table_name, "|")
        count = self.run_query_return_result(f'''select count(*) from "{table_name}" ''')[0]
        print(f"Neo4j result size is {count}")


if __name__ == '__main__':
    print("test")
