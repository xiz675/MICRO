import itertools
import random
import string

from utils.cypher_parser_util import CypherRewriter, CYPHER_CLAUSE, CypherParseInfo, CypherParser
from utils.sql_parser_util import SQLRewriter, SQLParseInfo, SQLParser


def generate_random_string():
    length = random.randint(1, 2)
    return ''.join(random.choice(string.ascii_lowercase) for _ in range(length))


def generate_var_name(global_vars):
    new_var_name = generate_random_string()
    while new_var_name in global_vars or new_var_name in CYPHER_CLAUSE:
        new_var_name = generate_random_string()
    return new_var_name


def generate_plans(input_list):
    subsets = []
    for r in range(len(input_list) + 1):
        subsets.extend([list(comb) for comb in itertools.combinations(input_list, r)])
    return subsets


class CrossRewriter:
    def __init__(self, sql_info: SQLParseInfo, cypher_info: CypherParseInfo, label_2_table_dict):
        # , processed_where_statements):
        self.sql_info = sql_info
        self.cypher_info = cypher_info
        self.label_2_table_dict = label_2_table_dict
        self.cypher_vars = cypher_info.all_vars
        self.neo4j_return_mapping = cypher_info.return_clause.return_mapping
        self.neo4j_join_only_var = cypher_info.return_clause.return_join_var
        self.sql_table_mapping = sql_info.from_mapping
        self.sql_select_mapping = sql_info.select_mapping

    # need to finish it in the run_workload method
    # @staticmethod
    # def store_table_as_nodes(label: str, table: str):
    #     store_table_cypher = f''''''
    #     return store_table_cypher

    def rewrite(self):
        cypher_rewriter = CypherRewriter(self.cypher_info, [])
        sql_rewriter = SQLRewriter(self.sql_info, [], self.label_2_table_dict)
        # modify the sql side
        sql_rewriter.rewrite([], [])
        return cypher_rewriter.to_cypher(), cypher_rewriter.to_count_cypher(), sql_rewriter.to_sql()


if __name__ == '__main__':
    # test the parsers
    # Example usage
    sql_query = """
    select Company0.name as name, Person0.firstName, Person0.lastName, neo4j.coid, neo4j.pid, City0.name, Country0.name, neo4j.ctid
    from neo4j,City City0, Person Person0, Company Company0, Country Country0
    where Country0.name = $paramCountryName and Company0.name = $paramCompanyName and Person0.firstName = $paramFirstName and neo4j.ctid = City0.id and neo4j.pid = Person0.id and neo4j.cid = Company0.id and neo4j.coid = Country0.id
    """

    cypher_query = """
    MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(ct:City)-[:IS_PART_OF]->(co:Country)
    RETURN p.id as pid, ct.id as ctid, co.id as coid, c.id as cid
    """

    sql_info = SQLParser(sql_query).parser()
    cypher_info = CypherParser(cypher_query, sql_info.select_mapping['neo4j']).parser()

    where_stmts = sql_info.join_condition
    moved_where_stmts = generate_plans(where_stmts)

    for crt_where_stmts in moved_where_stmts:
        cr = CrossRewriter(sql_info, cypher_info, crt_where_stmts)
        # todo: needs to have a preprocess of crt_where_stmts before
        moved_table_labels, rewritten_sql, rewritten_cypher = cr.rewrite()
        if len(crt_where_stmts) == len(where_stmts):
            rewritten_sql = None
        print("*************************************")
        print(rewritten_sql)
        print("=====")
        print(rewritten_cypher)
