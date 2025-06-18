from collections import defaultdict
import re
from collections import Counter
import random

from utils.cypher_rewrite_util import find_all_keywords_match, Variable, generate_var_name, prop_not_in_neo4j, \
    get_all_var_names, Clause, CYPHER_CLAUSE, VAR_PATTERN, VAR_PATTERN_WITH_PREDICATE, VAR_PROP_PATTERN, AGG_PATTERN
from utils.query_stats_util import Stats, CypherStats, SQLStats, get_path_len
from utils.sql_rewrite_util import RelationComponent, Table, RelationComponentWithPGProp


def reformulate_cypher(remaining_clauses: list[Clause]):
    return "\n".join([i.get_clause_text() for i in remaining_clauses])


# return the formulated sql query and sql stats
def reformulate_sql(sql_select_components: list[RelationComponent], sql_predicates: list[RelationComponent],
                    group_by_components: list[RelationComponent], var_to_return):
    # get var_name and table alias: Variable to Table
    # Variable to Table
    var_to_table = {}
    # table name to int
    table_alias_num = defaultdict(int)
    join_predicates = []

    for var in var_to_return:
        var_label = var.variable_label
        table_alias = var_label + str(table_alias_num[var_label])
        table_alias_num[var_label] += 1
        # table name is the node label name
        var_to_table[var] = Table(var_label, table_alias)
        join_predicates.append(f"neo4j.{var.variable_name}id = {table_alias}.id")

    all_tables = var_to_table.values()

    select_clause = "select " + ", ".join([i.to_sql(var_to_table) for i in sql_select_components]) + "\n"
    from_clause = "from neo4j," + ", ".join([f"{i.table_name} {i.table_alias}" for i in all_tables]) + "\n"
    where_clause = "where "
    having_predicate = False
    if len(sql_predicates) > 0:
        where_clause = where_clause + " and ".join([i.to_sql(var_to_table) for i in sql_predicates])
        having_predicate = True
    if len(join_predicates) > 0:
        if having_predicate:
            where_clause = where_clause + " and "
        where_clause = where_clause + " and ".join(join_predicates) + "\n"
    group_by_clause = ""
    if len(group_by_components) > 0:
        group_by_clause = "group by " + ", ".join([i.to_sql(var_to_table) for i in group_by_components])
    return select_clause + from_clause + where_clause + group_by_clause





def modify_cypher_node_labels(cypher_query):
    # if there are several large labels, use the smallest labels
    pattern = r':Person|:Forum|:Comment|:Message|:Post'
    matches = re.findall(pattern, cypher_query)
    if len(matches) >= 2:
        cypher_query = re.sub(':Person', ':Person1', cypher_query)
        cypher_query = re.sub(':Forum', ':Forum2', cypher_query)
        cypher_query = re.sub(':Comment', ':Comment2', cypher_query)
        cypher_query = re.sub(':Message', ':Message2', cypher_query)
        cypher_query = re.sub(':Post', ':Post2', cypher_query)
    else:
        # :Person :Person1
        cypher_query = replace_with_random_choice(cypher_query, ':Person', [':Person', ':Person1'])
        # :Forum :Forum1 :Forum2
        cypher_query = replace_with_random_choice(cypher_query, ':Forum', [':Forum', ':Forum1', ':Forum2'])
        # :Comment1 :Comment2
        cypher_query = replace_with_random_choice(cypher_query, ':Comment', [':Comment1', ':Comment2'])
        # :Message1: :Message2
        cypher_query = replace_with_random_choice(cypher_query, ':Message', [':Message1', ':Message2'])
        # :Post1: :Post2
        cypher_query = replace_with_random_choice(cypher_query, ':Post', [':Post1', ':Post2'])
    return cypher_query


def rewrite_cypher_to_cypher_and_sql(query: str, prop_mapping: dict):
    # a list of stats collected
    sql_stats = SQLStats()
    cypher_stats = CypherStats()

    # for formulating sql queries
    sql_select_components = []  # sql select components
    group_by_components = []  # sql group by components
    sql_where_predicates = []  # sql where predicates
    # it stores variables that need to be returned because a predicate on them has pg property from match or where
    # clause for with and return clauses afterward, need to add them
    var_to_return = set()

    # this is for processing the where clause to find the correct variable, this needs to store all variables
    var_name_2_var = defaultdict(list)

    has_agg = False
    cross_model_rewrite = False
    clauses = find_all_keywords_match(query, CYPHER_CLAUSE)
    global_vars = get_all_var_names(query)

    remaining_clauses = []
    for clause in clauses:
        clause_text = clause.get_clause_text()
        if clause.keyword.strip() == "match":
            # get the length of the path
            cypher_stats.add_path(get_path_len(clause_text))
            remaining_clauses.append(clause)
            # find all variables without predicates in node definition
            # for these variables, it is ok if they have no name
            for match in VAR_PATTERN.finditer(clause_text):
                variable_name = match.group(1)
                label_name = match.group(2)
                crt_variable = Variable(variable_name, label_name)
                # this means there will not be where predicates with it
                if variable_name is None or bool(re.match(r'^\s*$', variable_name)):
                    continue
                # this is for the where clauses, find the exact variable for the where clause
                var_name_2_var[variable_name].append(crt_variable)
            # for variables with predicates in their definitions, check if the predicate has property in pg,
            # if so, needs to change this variable's predicates, also, if the var name is empty, needs to assign a name
            # iterate from the end to the beginning, so that when modifying the later variable, the index of the
            # previous ones are kept the same
            matches = [match for match in re.finditer(VAR_PATTERN_WITH_PREDICATE, clause_text)][::-1]
            for match in matches:
                variable_name = match.group(1)
                label_name = match.group(2)
                predicate = match.group(3)
                all_preds = predicate.split(",")
                crt_variable = Variable(variable_name, label_name)
                rewrite = False
                # get each pred, check if it is in PG, if any is in PG, then need to add a var name for this var
                # for predicates in PG, remove them; for predicates in Neo4j, keep them, reformulate the string
                sql_preds = []
                remaining_preds = []
                for pred in all_preds:
                    prop = pred.split(":")[0].strip()
                    value = pred.split(":")[1].strip()
                    # needs to remove this predicate from cypher and add it to sql predicates if it is in pg
                    if prop_not_in_neo4j(label_name, prop, prop_mapping):
                        rewrite = True
                        sql_preds.append((prop, value))
                        # crt_sql_predicates.append(f"{variable_name}.{prop} = {value}")
                    else:
                        remaining_preds.append(pred)
                if rewrite:
                    # if the var name is empty, needs to assign a name
                    if variable_name is None or bool(re.match(r'^\s*$', variable_name)):
                        variable_name = generate_var_name(global_vars)
                        crt_variable.modify_var_name(variable_name)
                        global_vars.add(variable_name)
                    # modify Cypher clause by keeping only the predicates in neo4j
                    new_string = f"{variable_name}:{label_name}"
                    # change the clause
                    if len(remaining_preds) > 0:
                        new_string = new_string + "{" + ", ".join(remaining_preds) + "}"
                    # modify cypher query
                    new_string = f"({new_string})"
                    clause.modify_clause_substring(match.start(), match.end(), new_string)
                    # modify sql predicates
                    for i in sql_preds:
                        sql_where_predicates.append(
                            RelationComponentWithPGProp(crt_variable, f"{variable_name}.{i[0]} = {i[1]}"))
                    var_to_return.add(crt_variable)
                    # this keeps all vars with name
                if not (variable_name is None or bool(re.match(r'^\s*$', variable_name))):
                    var_name_2_var[variable_name].append(crt_variable)

        # for where clause, needs to check the predicates for each variable, there can be different variables there
        if clause.keyword.strip() == "where":
            remaining_clauses.append(clause)
            predicates = clause.get_clause_component().copy()
            for predicate in predicates:
                match = VAR_PROP_PATTERN.search(predicate)
                if match:
                    var_name = match.group(1)
                    prop = match.group(2)
                    if var_name not in var_name_2_var:
                        raise ValueError("Unspecified node type")
                    assert var_name in var_name_2_var
                    # get the last variable from the map
                    crt_var = var_name_2_var[var_name][-1]
                    # once it is in pg, remove the component
                    if prop_not_in_neo4j(crt_var.variable_label, prop, prop_mapping):
                        # modify cypher clause
                        clause.remove_clause_component(predicate)
                        # modify sql clause
                        sql_where_predicates.append(RelationComponentWithPGProp(crt_var, predicate))
                        var_to_return.add(crt_var)

        # for with clause, all the current var_to_return needs to be included
        if clause.keyword.strip() == "with" or clause.keyword.strip() == "with distinct":
            remaining_clauses.append(clause)
            for var in var_to_return:
                clause.add_clause_component(var.variable_name)

        if clause.keyword.strip() == "return":
            remaining_clauses.append(clause)
            # this is for group by clause, non-aggregate components in the return clause
            raw_return_components = clause.raw_clause_component

            # add these variables to return, but for sql select clause, should not add them
            if len(var_to_return) > 0:
                cross_model_rewrite = True
                for var in var_to_return:
                    clause.add_clause_component(f"{var.variable_name}.id as {var.variable_name}id")
                    # sql_select_components.append(RelationReturnComponent(var, f"{var.variable_name}.id", True))

            for comp in raw_return_components:
                is_in_neo4j = True
                sql_select_comp = comp
                # if comp is agg_comp, replace the aggregation function with id of the entity
                match = re.search(AGG_PATTERN, comp)
                if match:
                    has_agg = True
                    # get var name from it and check if there is any property in pg
                    function_params = match.group(2).split(" ")
                    comp_name = function_params[-1]
                    if comp_name == "*":
                        # if it is *, then remove it from cypher and put it in sql, crt_var will be none
                        sql_select_comp = comp
                        new_comp = ""
                        is_in_neo4j = False
                        crt_var = None
                    else:
                        if "." in comp_name:
                            var_name = comp_name.split(".")[0]
                            prop_name = comp_name.split(".")[1]
                        else:
                            # if there is no prop, need to add id prop
                            var_name = comp_name
                            prop_name = "id"
                            if len(function_params) > 1:
                                prefix = " ".join(function_params[:-1]) + " "
                            else:
                                prefix = ""
                            sql_select_comp = comp[:match.start(2)] + prefix + f"{comp_name}.id" + comp[match.end(2):]

                        # todo: if it is not in var_name, then the var name can be created from a subquery or edge var,
                        #  change it to agg_func(*)
                        if var_name not in var_name_2_var:
                            raise ValueError("Unspecified node type")

                        crt_var = var_name_2_var[var_name][-1]

                        if prop_not_in_neo4j(crt_var.variable_label, prop_name, prop_mapping):
                            is_in_neo4j = False
                            cross_model_rewrite = True
                            # if prop is in not in neo4j, replace aggregation to var.id
                            new_comp = comp.replace(comp, f"{var_name}.id as {var_name}id")
                            var_to_return.add(crt_var)
                        else:
                            # if prop is in neo4j, replace aggregation to var.prop
                            new_comp = comp.replace(comp, f"{var_name}.{prop_name} as {var_name}{prop_name}")

                # if it is not an aggregation, should put it in the non_agg_cypher
                else:
                    # regular component, not aggregation one
                    if "." in comp:
                        var_name = comp.split(".")[0].split(" ")[-1]
                        prop_name = comp.split(".")[1].split(" ")[0]
                    else:
                        # if there is no prop, need to add id prop
                        var_name = comp.split(" ")[0]
                        prop_name = "id"
                        sql_select_comp = f"{var_name}.id"

                    # if it is not in var_name, then the var name can be created from a subquery or edge var
                    if var_name not in var_name_2_var:
                        raise ValueError("Unspecified node type")

                    # add the non-aggregate component to group by list
                    crt_var = var_name_2_var[var_name][-1]

                    # if property does not exist in neo4j, then change it to id
                    if prop_not_in_neo4j(crt_var.variable_label, prop_name, prop_mapping):
                        is_in_neo4j = False
                        cross_model_rewrite = True
                        var_to_return.add(crt_var)
                        prop_name = "id"

                    group_by_components.append(RelationComponent(crt_var, sql_select_comp, is_in_neo4j))
                    # if prop in neo4j, return the var.prop, if not return var.id
                    new_comp = comp.replace(comp, f"{var_name}.{prop_name} as {var_name}{prop_name}")

                # modify cypher return clause
                clause.modify_clause_component(comp, new_comp)
                # modify sql: no matter if the comp is in neo4j or not, add to sql_return_components
                crt_comp = RelationComponent(crt_var, sql_select_comp, is_in_neo4j)
                sql_select_components.append(crt_comp)

    if not cross_model_rewrite:
        print("no rewriting needed")
        # raise ValueError("The query is not a cross model query")

    if not has_agg:
        group_by_components = []

    for var in var_to_return:
        sql_stats.touch_table(var.variable_label)

    cypher_query = reformulate_cypher(remaining_clauses)
    modified_cypher_query = modify_cypher_node_labels(cypher_query)
    sql_query = reformulate_sql(sql_select_components, sql_where_predicates, group_by_components, var_to_return)
    stats = Stats(sql_stats, cypher_stats)
    return modified_cypher_query, sql_query, stats


if __name__ == '__main__':
    # these are properties not in neo4j
    prop_mapping = {
        "City": ["name"],
        "Place": ["name"],
        "Country": ["name"],
        "Continent": ["name"],
        "Organisation": ["name"],
        "University": ["name"],
        "Company": ["name"],
        "TagClass": ["name"],
        "Tag": ["name"],
        "Forum": ["title", "creationDate"],
        "Person": ["email", "firstName", "lastName", "gender", "birthday", "speaks", "locationIP", "browserUsed"],
        "Post": ["creationDate", "content", "length", "locationIP", "browserUsed"],
        "Comment": ["creationDate", "content", "length", "locationIP", "browserUsed"],
        "Message": ["creationDate", "content", "length", "locationIP", "browserUsed"]
    }

    # test_query1 = """
    # MATCH  (:City {name: $cityName})<-[:IS_LOCATED_IN]-(person:Person {gender: $gender})<-[:HAS_MODERATOR]-
    # (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $tagClass})
    # RETURN  forum.id,  forum.title,  count(DISTINCT post) AS postCount ORDER BY   postCount DESC LIMIT 10\n;
    # """
    # cypher1, sql1 = rewrite_cypher_to_cypher_and_sql(test_query1, prop_mapping)
    # print("=" * 40)
    # print(f"Original cypher query:\n{test_query1}")
    # print(f"Cypher query:\n{cypher1}")
    # print(f"SQL query:\n{sql1}")
    #
    # # # test if it can rewrite forum in return clause to forum.id
    # test_query2 = """
    # MATCH (:City {name: $cityName})<-[:IS_LOCATED_IN]-(person:Person {gender: $gender})<-[:HAS_MODERATOR]-
    # (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $tagClass})
    # RETURN  forum,  forum.title,  count(DISTINCT post) AS postCount ORDER BY  postCount DESC LIMIT 10;
    # """
    # cypher2, sql2 = rewrite_cypher_to_cypher_and_sql(test_query2, prop_mapping)
    # print("=" * 40)
    # print(f"Original cypher query:\n{test_query2}")
    # print(f"Cypher query:\n{cypher2}")
    # print(f"SQL query:\n{sql2}")
    #
    # # test where test_query3 = """ MATCH (:City {name: $cityName})<-[:IS_LOCATED_IN]-(person:Person {gender:
    # $gender})<-[:HAS_MODERATOR]- (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(
    # tagClass:TagClass {name: $tagClass}) where post.creationDate > $date and tag.name = $name RETURN  forum ; """

    # read the llm generated cypher queries and rewrite it
    path_prefix = r"C:/Users/sauzh/Documents/Work/crossmodel/workloads/gpt-wo-agg-new/"
    cypher_path = path_prefix + r"correct_llm.cypher"
    cross_query_path = path_prefix + r"cross_model_queries.txt"

    with open(cypher_path, 'r') as file:
        cypher_str = file.read()
    cypher_queries = cypher_str.split(";")
    print(len(cypher_queries))

    global_stats = []
    count = 0

    with open(cross_query_path, 'w') as file:
        for query in cypher_queries:
            # print(query)
            try:
                if "starts with" in query.lower() or "ends with" in query.lower():
                    continue
                cypher, sql, stat = rewrite_cypher_to_cypher_and_sql(query, prop_mapping)
                count += 1
                file.write(cypher + "\n" + "*" * 10 + "\n")
                file.write(sql + "\n" + "#" * 10 + "\n")
                global_stats.append(stat)
            except ValueError as e:
                print(e)
    print(count)
    # get the path length of the decomposed cypher query
    path_len = [i.total_path_length for i in global_stats]
    path_len_dis = Counter(path_len)

    # get the number of relations touched
    num_visited_tables = [i.num_of_tables_touched for i in global_stats]
    num_tables_dis = Counter(num_visited_tables)

    # get the types of relations touched
    # visited_tables = [i.touched_table_types for i in global_stats]

    print(path_len_dis)
    print(num_tables_dis)
    # print(visited_tables)
