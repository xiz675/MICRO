import itertools
import random
import string
from collections import defaultdict
import re

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
    def __init__(self, sql_info: SQLParseInfo, cypher_info: CypherParseInfo,
                 label_2_table_dict=None):
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

    # todo: for label_2_table and table_2_label, it should be processed in different ways
    def rewrite(self, processed_where_statements):
        cypher_rewriter = CypherRewriter(self.cypher_info, processed_where_statements)
        sql_rewriter = SQLRewriter(self.sql_info, processed_where_statements, self.label_2_table_dict)
        all_var = list(self.cypher_vars.keys())[:]

        if self.label_2_table_dict:
            return self.rewrite_ldbc(processed_where_statements, cypher_rewriter, sql_rewriter, all_var)

        else:
            return self.rewrite_real_workloads(processed_where_statements, cypher_rewriter, sql_rewriter, all_var)

    def rewrite_ldbc(self, processed_where_statements, cypher_rewriter, sql_rewriter, all_var):
        # new neo4j prop alias
        new_neo4j_prop_alias = []
        table_moved_varname = []
        table_moved_labels = set()
        move_cols = defaultdict(set)
        # plan is a list of tuples: neo4j var.prop, table_var_name.col, table_label
        plan = []

        # table move to neo4j queries
        table_move_realnames = []

        for where_statement in processed_where_statements:
            left, right = where_statement
            if "neo4j" in left:
                neo4j_side, table_side = left, right
            else:
                neo4j_side, table_side = right, left
            crt_var = generate_var_name(all_var)
            all_var.append(crt_var)
            neo4j_alias = neo4j_side.split(".")[-1]
            neo4j_var_prop = self.neo4j_return_mapping[neo4j_alias]
            # neo4j_var, neo4j_prop = self.neo4j_return_mapping[neo4j_alias].split(".")
            table_varname, table_col = table_side.split(".")
            crt_label = self.sql_table_mapping[table_varname]
            move_cols[crt_label].add(table_col)
            cols = self.sql_select_mapping[table_varname]
            move_cols[crt_label].update(cols)
            # modify the cypher side, if the var.prop is used for join only and not in the final select clause, then
            # remove the corresponding return component from neo4j
            cypher_rewriter.rewrite(crt_var, crt_label, neo4j_var_prop, neo4j_alias, table_col, cols,
                                    self.neo4j_join_only_var)
            table_moved_varname.append(table_varname)
            table_moved_labels.add(crt_label)
            # todo: the crt_label now should be the neo4j's label
            plan.append((neo4j_var_prop, table_side, self.cypher_vars[neo4j_var_prop.split(".")[0]], crt_label))
            new_neo4j_prop_alias.extend([f"{crt_var}{col}" for col in cols])

        # modify the sql side
        sql_rewriter.rewrite(table_moved_varname, new_neo4j_prop_alias)

        for label in table_moved_labels:
            table = self.label_2_table_dict[label]
            table_move_realnames.append((table, label, move_cols))
        return plan, table_move_realnames, cypher_rewriter.to_cypher(), cypher_rewriter.to_count_cypher(), sql_rewriter.to_sql()

    def rewrite_real_workloads(self, processed_where_statements, cypher_rewriter, sql_rewriter, all_var):
        # new neo4j prop alias
        new_neo4j_prop_alias = []
        table_moved_varname_2_name = {}
        # real name 2 the columns to be moved
        move_cols = defaultdict(set)
        # plan is a list of tuples: neo4j var.prop, table_var_name.col, table_label
        plan = []
        # table move to neo4j queries
        table_move_realnames = []

        for where_statement in processed_where_statements:
            left, right = where_statement
            if "neo4j" in left:
                neo4j_side, table_side = left, right
            else:
                neo4j_side, table_side = right, left
            crt_var = generate_var_name(all_var)
            all_var.append(crt_var)
            neo4j_alias = neo4j_side.split(".")[-1]
            neo4j_var_prop = self.neo4j_return_mapping[neo4j_alias]
            # neo4j_var, neo4j_prop = self.neo4j_return_mapping[neo4j_alias].split(".")
            # tabel_varname is table alias, use this as the label
            table_varname, table_col = table_side.split(".")
            table_real_name = self.sql_table_mapping[table_varname]

            move_cols[table_real_name].add(table_col)
            cols = self.sql_select_mapping[table_varname]
            move_cols[table_real_name].update(cols)
            # modify the cypher side, if the var.prop is used for join only and not in the final select clause, then
            # remove the corresponding return component from neo4j
            cypher_rewriter.rewrite(crt_var, table_varname, neo4j_var_prop, neo4j_alias, table_col, cols,
                                    self.neo4j_join_only_var)
            table_moved_varname_2_name[table_varname] = table_real_name
            plan.append((neo4j_var_prop, table_side, self.cypher_vars[neo4j_var_prop.split(".")[0]], table_varname))
            new_neo4j_prop_alias.extend([f"{crt_var}{col}" for col in cols])

        # modify the sql side
        sql_rewriter.rewrite(list(table_moved_varname_2_name.keys()), new_neo4j_prop_alias)
        # todo: for the previous ldbc experiment, each label's associated table is only one
        for tv in table_moved_varname_2_name:
            crt_real_name = table_moved_varname_2_name[tv]
            table_move_realnames.append((crt_real_name, tv, move_cols[crt_real_name]))
        return plan, table_move_realnames, cypher_rewriter.to_cypher(), cypher_rewriter.to_count_cypher(), sql_rewriter.to_sql()





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
