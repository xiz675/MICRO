# generate relationship tables from the relationship csv files, for some tables, need to combine several csv files, and
#  add filter columns
# only extract relevant columns
import argparse
import glob
import re
from io import StringIO

from pandas.errors import EmptyDataError, ParserError

from utils.neo4j_utils import Neo4jUtil
from utils.pg_utils import PostgresUtil
import pandas as pd

# Define the pattern for the CSV files (part-*.csv)
file_pattern = 'part-*.csv*'
ddl_prefix = '''./ddl/'''
schema_path = ddl_prefix + '''entity_tables.sql'''
static_entities = ["Organisation", "Place", "Tag", "TagClass"]
dynamic_entities = ["Comment", "Forum", "Person", "Post"]
static_edges = ["Place_isPartOf_Place", "Organisation_isLocatedIn_Place", "Tag_hasType_TagClass",
                "TagClass_isSubclassOf_TagClass"]
dynamic_edges = ["Forum_hasMember_Person", "Person_likes_Post", "Comment_hasCreator_Person",
                 "Forum_hasModerator_Person",
                 "Person_studyAt_University", "Comment_hasTag_Tag", "Forum_hasTag_Tag", "Person_workAt_Company",
                 "Comment_isLocatedIn_Country", "Comment_replyOf_Comment", "Person_hasInterest_Tag",
                 "Post_hasCreator_Person",
                 "Comment_replyOf_Post", "Person_isLocatedIn_City", "Post_hasTag_Tag", "Forum_containerOf_Post",
                 "Person_knows_Person",
                 "Post_isLocatedIn_Country", "Person_likes_Comment"]


# only read relevant columns
def load_schema(create_tables_sql: str):
    # load the schema file and return the schema of each table and the columns of each table
    pattern = re.compile(r'(CREATE TABLE\s*(\w+)\s*\((.*?)\))', re.DOTALL)
    matches = pattern.findall(create_tables_sql)
    table_creation = {}
    columns = {}
    for match in matches:
        sql_query = match[0].strip()
        table_name = match[1].strip()
        table_content = match[2].strip()
        table_creation[table_name] = sql_query
        cols = [i.strip().split(" ")[0] for i in table_content.split(",")]
        columns[table_name] = cols
    return table_creation, columns


def get_headers(header_file: str):
    headers_map = {}
    static_header_prefix = header_file + "/static/"
    dynamic_header_prefix = header_file + "/dynamic/"
    for en in static_entities + dynamic_entities + static_edges + dynamic_edges:
        if en in static_entities + static_edges:
            file_path = f'{static_header_prefix}{en}.csv'
        else:
            file_path = f'{dynamic_header_prefix}{en}.csv'
        df = pd.read_csv(file_path, sep="|", header=0)
        if en in static_entities + dynamic_entities:
            col_names = [i.split(":")[0].strip() for i in list(df.columns)]
            if "identity" in col_names:
                col_names[col_names.index("identity")] = "id"
            if "" in col_names:
                col_names[col_names.index("")] = "type"
        else:
            col_names = list(df.columns)
            # if it is an edge, modify the :startid(xxx) to startid, :endid(xxx) to endid
            for i in range(len(col_names)):
                if "START_ID" in col_names[i]:
                    col_names[i] = "start_id"
                if "END_ID" in col_names[i]:
                    col_names[i] = "end_id"
        headers_map[en] = col_names
    return headers_map


def read_create_table_file(file_path):
    with open(file_path, 'r') as file:
        sql_content = file.read()
    return sql_content


def create_all_tables(table_creation: dict, db_util: PostgresUtil):
    for table in table_creation:
        db_util.run_query(table_creation[table])


def read_single_csv_file(file_path: str):
    df = pd.DataFrame()
    try:
        if file_path.endswith('.gz'):
            df = pd.read_csv(file_path, sep="|", header=None, compression='gzip')
        else:
            df = pd.read_csv(file_path, sep="|", header=None)
    except (EmptyDataError, ParserError) as e:
        print(f"Error reading file {file_path}: {e}")
        print(f"Skipping file: {file_path}")
    return df


def read_all_data_files(directory_path: str, cols_index: list[int]) -> list[pd.DataFrame]:
    """
    :param col_selected: the names for selected columns
    :param directory_path: path for csv files
    :param cols_index: a list of index for columns selected
    :return: a list of dataframes and the maximum of id
    """
    file_list = glob.glob(f'''{directory_path}/{file_pattern}''')
    all_dfs = []
    assert len(file_list) > 0
    # read all data files
    raw_row_count = 0
    for file in file_list:
        df = read_single_csv_file(file)
        if df.empty:
            continue
        df = df.iloc[:, cols_index]
        # df.columns = col_selected
        all_dfs.append(df)
        raw_row_count += df.shape[0]
    print(f"Table size: {raw_row_count}")
    return all_dfs


def create_dataset(pg_util: PostgresUtil, path: str, col_index: list[int], table: str):
    # read all csv files to pd
    data_dfs = read_all_data_files(path, col_index)
    result_df = pd.concat(data_dfs, ignore_index=True)
    buffer = StringIO()
    # Convert DataFrame to a CSV string in-memory
    result_df.to_csv(buffer, index=False, header=False, sep='|')
    buffer.seek(0)
    # load the file to database
    pg_util.copy_from_pd(buffer, table.lower(), "|")


def create_entity_tables(pg_util: PostgresUtil, data_path: str, headers: dict):
    static_path = f'''{data_path}/static/'''
    dynamic_path = f'''{data_path}/dynamic/'''
    # read table creation sql file
    schema_sql = read_create_table_file(schema_path)
    # get creation sql query and the columns for each table
    # if the table is an edge, the cols_selected will be startid, endid
    table_creation, table_cols = load_schema(schema_sql)
    # create all tables in database
    create_all_tables(table_creation, pg_util)
    # create data for each table
    for table in table_creation:
        if table in dynamic_entities + dynamic_edges:
            path = dynamic_path + table
        elif table in static_entities + static_edges:
            path = static_path + table
        else:
            print(f"{table} does not exist")
            continue

        if table in dynamic_edges + static_edges:
            cols_selected = ["start_id", "end_id"]
        else:
            cols_selected = table_cols[table]
        # get the selected column index
        header = headers[table]
        # get the index of selected cols
        col_indices = []
        for col in cols_selected:
            col_indices.append(header.index(col))
        # read all files for table, return a list of dfs except empty df, with only selected columns,
        # and return the max index value
        print(f"======== Read table {table} ========")
        # copy the specific cols in the csv file to postgres
        create_dataset(pg_util, path, col_indices, table)


# generate the filter tables from the neo4j node labels
def move_neo4j_to_pg(label_name: str, neo4j_util: Neo4jUtil, pg_util: PostgresUtil):
    # cypher query to select nodes with the label, create the filter tables.
    # filter table name: filter_NodeLabel, column id
    cypher_query = f"Match (n:{label_name}) return n.id as id"
    neo4j_util.generate_filter_table(cypher_query, f"filter_{label_name}".lower(), pg_util)


if __name__ == '__main__':
    # get the data file path, database connection info etc from args
    # get db connection detail and data dir from command line args
    # Create the parser
    parser = argparse.ArgumentParser(description='Process command line arguments.')

    # Add the argument for the tables to use in the Postgres
    # Add arguments for Neo4j
    parser.add_argument('--nj-uri', dest='nj_uri', default='bolt://localhost:7687', type=str, help='Neo4j database URI')
    parser.add_argument('--nj-db', dest='nj_db', default='neo4j', type=str, help='Neo4j database name')
    parser.add_argument('--nj-user', dest='nj_user', default='neo4j', type=str, help='Neo4j user name')
    parser.add_argument('--nj-pw', dest='nj_pw', default='1996AHtc!', type=str, help='Neo4j password')

    # Add arguments for PostgreSQL
    parser.add_argument('--pg-host', dest='pg_host', default='localhost', type=str, help='PostgreSQL database host')
    parser.add_argument('--pg-db', dest='pg_db', default='postgres', type=str, help='PostgreSQL database name')
    parser.add_argument('--pg-user', dest='pg_user', default='postgres', type=str, help='PostgreSQL user name')
    parser.add_argument('--pg-pw', dest='pg_pw', default='xw', type=str, help='PostgreSQL password')

    parser.add_argument('--data-dir', dest='data_dir', type=str, required=True)
    parser.add_argument('--header-file', dest='header_file', type=str, required=True)

    # Parse the command line arguments
    args = parser.parse_args()

    # Read the data directory
    data_dir = args.data_dir

    # connect to neo4j database to check if the modified queries and plans are correct
    neo4j_util = Neo4jUtil(args.nj_uri, args.nj_user, args.nj_pw, args.nj_db)
    # connect to pg database
    db_util = PostgresUtil(args.pg_db, args.pg_user, args.pg_pw, args.pg_host)
    db_util.connect()

    # get all headers and store them in a map
    headers = get_headers(args.header_file)
    create_entity_tables(db_util, data_dir, headers)

    NODE_LABELS = ["Forum1", "Forum2", "Comment1", "Comment2", "Comment3", "Message1", "Message2", "Message3", "Post1",
                   "Post2", "Post3", "Person1", "Person2", "Person3"]

    for label in NODE_LABELS:
        move_neo4j_to_pg(label, neo4j_util, db_util)

    # renames the tables and generate the union for some tables
    with open("./ddl/alter_tables.sql", 'r') as file:
        sql_script = file.read()

    db_util.run_query(sql_script)

    # --header-file "C:\Users\sauzh\.Neo4jDesktop\relate-data\dbmss\dbms-10166248-489f-4d7f-bf5d-5bbaed3efebc\headers"
    # --data-dir "C:\Users\sauzh\.Neo4jDesktop\relate-data\dbmss\dbms-10166248-489f-4d7f-bf5d-5bbaed3efebc\import\initial_snapshot"