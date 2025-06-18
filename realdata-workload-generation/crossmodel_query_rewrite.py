import re
from collections import defaultdict
import random

from utils.cypher_rewrite_util import find_all_keywords_match, CYPHER_CLAUSE, get_all_var_names, Variable, \
    generate_var_name, VAR_PATTERN_WITH_OPTIONAL_PROPS
from utils.llm_correction_util import read_and_process_llm_queries
from utils.sql_rewrite_util import Table


def choose_random_join_vars(lst: list[str]):
    if len(lst) <= 3:
        return lst
    else:
        k = random.randint(3, len(lst))  # pick a number ≥ 3
        return random.sample(lst, k)


def replace_with_random_choice(text, substring, replacements):
    new_text = re.sub(substring, random.choice(replacements), text)
    return new_text


class Entity:
    def __init__(self, node_label: str, node_prop: str, relation_name: str, relation_col: str):
        self.node_label = node_label
        self.node_prop = node_prop
        self.relation_name = relation_name
        self.relation_col = relation_col

    def get_joined_col(self):
        return self.relation_name + "." + self.relation_col

    def get_join_condition(self, node_var: str, relation_var: str):
        return f"""{node_var}.{self.node_prop} = {relation_var}.{self.relation_col}"""


# todo: I should just keep the Cypher part with only modifications are to add the var names, and return the vars that
#  are going to be joined with the relation part
def modify_cypher_node_labels(old_query):
    # if there are several large labels, use the smallest labels
    pattern = r':Author|:Institution|:Work|:Topic'
    matches = re.findall(pattern, old_query)
    if len(matches) >= 2:
        old_query = re.sub(':Author', ':Author2', old_query)
        old_query = re.sub(':Institution', ':Institution2', old_query)
        old_query = re.sub(':Work', ':Work3', old_query)
        old_query = re.sub(':Topic', ':Topic1', old_query)
    else:
        old_query = replace_with_random_choice(old_query, ':Author',
                                               [':Author', ':Author1', ':Author2'])
        old_query = replace_with_random_choice(old_query, ':Institution',
                                               [':Institution', ':Institution1', ':Institution2'])
        old_query = replace_with_random_choice(old_query, ':Work',
                                               [':Work', ':Work1', ':Work2'])
        old_query = replace_with_random_choice(old_query, ':Topic',
                                               [':Topic', ':Topic1'])
    return old_query


def rewrite_cypher_to_cypher_and_sql(query: str, entity_dict: dict[str, Entity]):
    # # this is for stats, can omit for now
    # sql_stats = SQLStats()
    # cypher_stats = CypherStats()

    # for formulating sql queries
    sql_select_components = []  # sql select components
    sql_join_predicates = []  # sql join predicates
    sql_from_components = []
    join_num = 0
    # cypher return part due to join with table
    var_to_return = set()

    var_name_2_var = {}
    # the same table can be joined more than once, so need a number for alias
    table_alias_num = defaultdict(int)

    clauses = find_all_keywords_match(query, CYPHER_CLAUSE)
    global_vars = get_all_var_names(query)

    for clause in clauses:
        clause_text = clause.get_clause_text()
        # todo: process the match and return part, the where part can be skipped, the major modification is to add
        #  var names to labels, and choose vars to join, and if the var is chosen to be joined, return the var name
        #  and join property in the return clause get all the variables, if the var does not have a name, add a name
        if clause.keyword.strip() == "match":
            # if it is regular variable match
            matches = [match for match in re.finditer(VAR_PATTERN_WITH_OPTIONAL_PROPS, clause_text)][::-1]
            for match in matches:
                variable_name = match.group(1)
                label_name = match.group(2)
                crt_variable = Variable(variable_name, label_name)
                # this means there will not be where predicates with it
                if variable_name is None or bool(re.match(r'^\s*$', variable_name)):
                    # add a name to the var
                    variable_name = generate_var_name(global_vars)
                    crt_variable.modify_var_name(variable_name)
                    global_vars.add(variable_name)
                    # add the var name to the original variable
                    new_string = f"({variable_name}:{label_name})"
                    clause.modify_clause_substring(match.start(), match.end(), new_string)
                var_name_2_var[variable_name] = crt_variable
    join_able_vars = {}
    for var in var_name_2_var:
        if var_name_2_var[var].variable_label in entity_mapping.keys():
            join_able_vars[var] = var_name_2_var[var]
    # randomly chose variables to be joined
    chosen_join_var = choose_random_join_vars(list(join_able_vars.keys()))
    join_num = len(chosen_join_var)
    # for each chosen vars, add the join prop to cypher return and get the sql join predicates
    for var in chosen_join_var:
        variable = join_able_vars[var]
        var_label = variable.variable_label
        var_name = variable.variable_name
        join_entity = entity_dict[var_label]
        var_prop, rel_name, rel_col = join_entity.node_prop, join_entity.relation_name, join_entity.relation_col
        # todo: modify the relation by attaching different number to it, the larger number it is, the more filter rate
        value = random.randint(0, 2)
        if value > 0:
            rel_name = rel_name + str(value)
        table_alias = var_label + str(table_alias_num[var_label])
        table_alias_num[var_label] += 1
        sql_join_predicates.append(f"neo4j.{var_name}{var_prop} = {table_alias}.{rel_col}")
        var_to_return.add(f"{var_name}.{var_prop} as {var_name}{var_prop}")
        sql_from_components.append(Table(rel_name, table_alias))

    # for the cypher return clause, modify it to add the joined prop and construct the SQL select components
    # process return
    for clause in clauses:
        if clause.keyword != "return":
            continue
        raw_return_components = clause.raw_clause_component
        for i in var_to_return:
            clause.add_clause_component(i)
        for comp in raw_return_components:
            # if comp does not have var prop, add an "id" col
            if "." in comp:
                var_name = comp.split(".")[0].split(" ")[-1]
                prop_name = comp.split(".")[1].split(" ")[0]
                sql_select_comp = f"neo4j.{var_name}{prop_name}"
            else:
                var_name = comp.split(" ")[0]
                prop_name = "id"
                sql_select_comp = f"neo4j.{var_name}id"
            # rewrite it to {var_name}{var_prop}
            new_comp = f"{var_name}.{prop_name} as {var_name}{prop_name}"
            clause.modify_clause_component(comp, new_comp)
            sql_select_components.append(sql_select_comp)

    # formulate Cypher query
    cypher_query = "\n".join([i.get_clause_text() for i in clauses])

    # formulate SQL query
    sql_query = ("select " + ", ".join(sql_select_components) + "\n" +
                 "from neo4j, " + ", ".join([f"{i.table_name} {i.table_alias}" for i in sql_from_components]) + "\n" +
                 "where " + " and ".join(sql_join_predicates))
    cypher_query = modify_cypher_node_labels(cypher_query)
    return cypher_query, sql_query, join_num


if __name__ == '__main__':
    path_prefix = r"C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/"
    query_path = "correct_llm_with_dir.cypher"
    cross_query_path = path_prefix + r"cross_model_queries.txt"
    # queries = read_and_process_llm_queries(path_prefix + query_path)
    # with open(path_prefix + 'clean_llm.cypher', 'w') as file:
    #     file.write(';\n'.join(queries))
    with open(path_prefix+query_path, 'r') as file:
        cypher_str = file.read()
    queries = cypher_str.split(";")
    entity_mapping = {
        "Author": Entity("Author", "name", "uspto.inventors", "name"),
        "Institution": Entity("Institution", "ror", "uspto.institution", "ror"),
        "Topic": Entity("Topic", "id", "uspto.topic_patent", "id"),
        "Subfield": Entity("Subfield", "id", "uspto.subfield_patent", "id"),
        "Field": Entity("Field", "id", "uspto.field_patent", "id"),
        "Work": Entity("Work", "name", "uspto.publication_cited_by_patent", "name")
    }
    with open(cross_query_path, 'w') as file:
        for query in queries:
            cypher_query, sql_query, join_num = rewrite_cypher_to_cypher_and_sql(query, entity_mapping)
            if join_num < 2:
                continue
            file.write(cypher_query + "\n" + "*" * 10 + "\n")
            file.write(sql_query + "\n" + "#" * 10 + "\n")
            print(cypher_query)
            print(sql_query)
