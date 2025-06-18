import json
import os
import random
import re
from collections import defaultdict
from pathlib import Path

from utils.cypher_rewrite_util import find_all_keywords_match
from utils.sql_rewrite_util import split_queries, remove_stars

SQL_CLAUSE = ["select", "from", "where"]
EDGE_PATTERN = r"(?=(\(\s*(\w*)\s*:?(\w*)\s*\)\s*[-<]*\[\s*\w*\s*:(\w*)\s*\]\s*[->]*\(\s*(\w*)\s*:?(\w*)\s*\)))"
EDGE_RELATION_MAPPING = {
    "IS_PART_OF": ("Place_isPartOf_Place", "subreg_id", "reg_id"),
    "IS_SUBCLASS_OF": ("TagClass_isSubclassOf_TagClass", "subtag_id", "tag_id"),
    "IS_LOCATED_IN": {
        ("Organisation", "Place"): ("Organisation_isLocatedIn_Place", "org_id", "loc_id"),
        ("Message", "Place"): ("Message_isLocatedIn_Place", "message_id", "loc_id"),
        ("Person", "Place"): ("Person_isLocatedIn_Place", "person_id", "loc_id"),
    },
    "HAS_TYPE": ("Tag_hasType_TagClass", "tag_id", "tagclass_id"),
    "CONTAINER_OF": ("Forum_containerOf_Message", "forum_id", "post_id"),
    "HAS_MEMBER": ("Forum_hasMember_Person", "forum_id", "person_id"),
    "HAS_MODERATOR": ("Forum_hasModerator_Person", "forum_id", "person_id"),
    "HAS_INTEREST": ("Person_hasInterest_Tag", "person_id", "tag_id"),
    "HAS_CREATOR": ("Message_hasCreator_Person", "message_id", "person_id"),
    "REPLY_OF": ("Message_replyOf_Message", "message_id", "replied_message_id"),
    "HAS_TAG": {
        ("Forum", "Tag"): ("Forum_hasTag_Tag", "forum_id", "tag_id"),
        ("Message", "Tag"): ("Message_hasTag_Tag", "message_id", "tag_id")
    },
    "STUDY_AT": ("Person_studyAt_Organisation", "person_id", "university_id"),
    "WORK_AT": ("Person_workAt_Organisation", "person_id", "company_id"),
    "KNOWS": ("Person_knows_Person", "person_id", "friend_id"),
    "LIKES": ("Person_likes_Message", "person_id", "message_id")
}

replaceable_nodes = {
    "Continent": "Place",
    "Country": "Place",
    "City": "Place",
    "University": "Organisation",
    "Company": "Organisation",
    "Comment": "Message",
    "Post": "Message"
}


class InvalidQueryError(Exception):
    pass


def process_node(node_var: str, node_label: str, num_of_filter_table: int,
                 join_with_filter: dict, filter_types: list, alias_rels: dict):
    # if it has number, should join with a filter relation
    if re.search(r'\d+', node_label):
        filter_table_name = f"filter_{node_label}"
        filter_table_alias = f"f{num_of_filter_table}"
        num_of_filter_table += 1
        join_with_filter[node_var].append(f"{filter_table_alias}.id")
        alias_rels[filter_table_alias] = filter_table_name
        node_label = re.sub(r'\d+', '', node_label)
    if node_label in replaceable_nodes:
        filter_table_name = replaceable_nodes[node_label]
        filter_table_alias = f"f{num_of_filter_table}"
        num_of_filter_table += 1
        join_with_filter[node_var].append(f"{filter_table_alias}.id")
        alias_rels[filter_table_alias] = filter_table_name
        filter_types.append(f"{filter_table_alias}.type='{node_label}'")
        node_label = filter_table_name
    return node_label, num_of_filter_table


def process_cypher_query(cypher_query: str):
    # match each path, get the mapping from variable to relation and column
    # if the variable is already in the map, then do a join
    # the parse result from cypher query will be:
    # 1. mapping from alias to relation
    # 2. mapping from return alias to relation alias and column
    # 3. filter column for subtypes
    # 4. joins between relations (which were in neo4j part)
    cypher_query = cypher_query.rstrip(';\n\r ')
    path_joins = []
    # alias to relation real name
    alias_rels = {}
    # variables to edge relation column
    var_rels_cols = {}
    select_predicates = {}
    num_of_edges = 0
    num_of_filter_table = 0
    processed_vars = set()
    join_with_filter = defaultdict(list)
    filter_types = []
    matches = re.finditer(EDGE_PATTERN, cypher_query)
    # variable to its label
    var_label = {}

    for match in matches:
        full_path, node1_var, node1_label, edge_label, node2_var, node2_label = match.groups()
        # if any label has a number in it, remove the number to find the corresponding relation, but add a join
        if node1_label == '':
            node1_label = var_label[node1_var]
        if node2_label == '':
            node2_label = var_label[node2_var]

        if node1_var not in processed_vars:
            node1_label, num_of_filter_table = process_node(node1_var, node1_label, num_of_filter_table,
                                                            join_with_filter, filter_types, alias_rels)
            processed_vars.add(node1_var)
            var_label[node1_var] = node1_label
        else:
            node1_label = var_label[node1_var]

        if node2_var not in processed_vars:
            node2_label, num_of_filter_table = process_node(node2_var, node2_label, num_of_filter_table,
                                                            join_with_filter, filter_types, alias_rels)
            processed_vars.add(node2_var)
            var_label[node2_var] = node2_label
        else:
            node2_label = var_label[node2_var]


        rel = EDGE_RELATION_MAPPING[edge_label]
        if ">" in full_path:
            left_label, right_label = node1_label, node2_label
            left_var, right_var = node1_var, node2_var
        else:
            left_label, right_label = node2_label, node1_label
            left_var, right_var = node2_var, node1_var
        # todo: handle undirected edges, the easiest way is to add direction by myself
        if isinstance(rel, dict):
            rel_name, left_col, right_col = rel[(left_label, right_label)]
        else:
            rel_name, left_col, right_col = rel

        alias = f"e{num_of_edges}"
        num_of_edges += 1
        alias_rels[alias] = rel_name
        left_var_col = f"{alias}.{left_col}"
        right_var_col = f"{alias}.{right_col}"

        # if the variable was defined before, then initiate a table join
        if left_var in var_rels_cols:
            path_joins.append((var_rels_cols[left_var], left_var_col))
            # # the empty string should only be matched one time
            # if left_var == "":
            #     print(f"SUSPECT: {cypher_query}")
        # else map the variable name to table.col
        else:
            var_rels_cols[left_var] = left_var_col
        if right_var in var_rels_cols:
            path_joins.append((var_rels_cols[right_var], right_var_col))
            # if right_var == "":
            #     print(f"SUSPECT: {cypher_query}")
        else:
            var_rels_cols[right_var] = right_var_col

    for var_name in join_with_filter:
        for col in join_with_filter[var_name]:
            # add the node filter join to the path joins, since the node var_name to col is defined now
            path_joins.append((col, var_rels_cols[var_name]))

    # get the return clause, check if for each var, it returns id, if so, return the table.col stored in the map
    match = re.search(r'(?i)\bRETURN\b(.*)', cypher_query)
    return_clause = match.group(1).strip()
    return_components = [i.strip() for i in return_clause.split(",")]
    for component in return_components:
        # get the var name, check if the attribute is id, get the alias of the returned col
        var_alias = [i.strip() for i in re.split(r'(?i)\bAS\b', component)]
        assert len(var_alias) == 2
        var_prop = var_alias[0].split(".")
        if var_prop[-1] != "id":
            raise InvalidQueryError("query invalid")
        var_name = var_prop[0]
        prop_alias = var_alias[1]
        if var_name not in var_rels_cols:
            raise InvalidQueryError("path not detected")
        select_predicates[prop_alias] = var_rels_cols[var_name]
    return alias_rels, path_joins, filter_types, select_predicates


def process_sql_query(sql_query: str):
    clauses = find_all_keywords_match(sql_query, SQL_CLAUSE)
    select_component, from_component, where_component = [], [], []
    for clause in clauses:
        if clause.keyword.strip() == 'select':
            select_component = clause.get_clause_component()
        if clause.keyword.strip() == 'from':
            from_component = clause.get_clause_component()
        if clause.keyword.strip() == "where":
            where_component = clause.get_clause_component()
    return list(select_component), list(['r_'+i.lower().lstrip() for i in from_component]), list(where_component)


def cross_model_queries_to_sql(cypher_query: str, sql_query: str):
    alias_rels, path_joins, filter_types, select_predicates = process_cypher_query(cypher_query)
    select_component, from_component, where_component = process_sql_query(sql_query)
    sql_select, sql_where = [], []

    for i in select_component:
        if 'neo4j' in i:
            sql_select.append(select_predicates[i.split('.')[-1].strip()].lower())
        else:
            sql_select.append(i.lower())
    from_component.extend([f"{value.lower()} {key.lower()}" for key, value in alias_rels.items()])
    from_component.remove("r_neo4j")

    for i in where_component:
        if '$' in i:
            continue
        if 'neo4j' in i:
            left, right = [j.strip() for j in i.split("=")]
            new_left, new_right = left, right
            if 'neo4j' in left:
                new_left = select_predicates[left.split(".")[-1].strip()]
            else:
                new_right = select_predicates[right.split(".")[-1].strip()]
            sql_where.append(f"{new_left.lower()} = {new_right.lower()}")
        else:
            sql_where.append(i.lower())
    sql_where.extend(filter_types)
    sql_where.extend([f"{t1.lower()}={t2.lower()}" for (t1, t2) in path_joins])

    return ("SELECT " + ", ".join(sql_select) + "\n" + "FROM " + ", ".join(from_component) + "\n" +
            "WHERE " + " and ".join(sql_where))


def rewrite_cm_queries_to_sql(cm_queries: str, remove_star=False):
    sql_queries = []
    cross_model_queries = [i.strip() for i in cm_queries.split("##########") if i != ""]
    for query in cross_model_queries:
        if remove_star:
            query = remove_stars(query)
        crt_cm_query = [i.strip() for i in query.split("**********")]
        if '*' in crt_cm_query[0] or '|' in crt_cm_query[0]:
            sql_queries.append('TODO')
            continue
        try:
            crt_sql_query = cross_model_queries_to_sql(crt_cm_query[0], crt_cm_query[1])
            sql_queries.append(crt_sql_query)
        except InvalidQueryError:
            sql_queries.append('Invalid query TODO')
            continue
    return sql_queries


if __name__ == '__main__':
    cross_model_query_path = r"C:\Users\sauzh\Documents\Work\crossmodel\workloads\gpt-wo-agg-new\cross-model-query"
    sql_query_dir = r"C:\Users\sauzh\Documents\Work\crossmodel\workloads\gpt-wo-agg-new\sql-query"
    # get the training queries, test queries, training query dict and test query dict
    train_sql_queries = []
    test_sql_queries = []
    train_queries = []
    test_queries = []

    for f in os.scandir(cross_model_query_path):
        file_name = f.name
        match = re.search(r'part_(\d+)', file_name)
        if match is not None and int(match.group(1)) > 50:
            continue
        if match is not None:
            concise_file_name = "part_" + match.group(1)

        with open(f.path, 'r') as file:
            queries = file.read()

        sql_queries = rewrite_cm_queries_to_sql(queries)

        train_idx, test_idx = split_queries(len(sql_queries))

        train_queries.extend([queries[i] for i in train_idx])
        test_queries.extend([queries[i] for i in test_idx])

        train_sql_queries.extend([sql_queries[i] for i in train_idx])
        test_sql_queries.extend([sql_queries[i] for i in test_idx])

    Path(os.path.join(sql_query_dir, "train.sql")).write_text(";\n".join(train_queries))
    Path(os.path.join(sql_query_dir, "test.sql")).write_text(";\n".join(test_queries))
    Path(os.path.join(sql_query_dir, "train.txt")).write_text("\n##########\n".join(train_queries))
    Path(os.path.join(sql_query_dir, "test.txt")).write_text("\n##########\n".join(test_queries))