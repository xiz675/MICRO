import random
import re

from utils.cypher_rewrite_util import Variable, Clause, find_all_keywords_match

SQL_CLAUSE = ["select", "from", "where"]
EDGE_PATTERN = r"(?=(\(\s*(\w*)\s*:?(\w*)\s*\)\s*[-<]*\[\s*\w*\s*:(\w*)\s*\]\s*[->]*\(\s*(\w*)\s*:?(\w*)\s*\)))"


class InvalidQueryError(Exception):
    pass


class Table:
    def __init__(self, table_name: str, table_alias: str):
        self.table_name = table_name
        self.table_alias = table_alias


# class RelationPredicates:
#     def __init__(self, var: Variable, predicates: list[str]):
#         self.var = var
#         self.predicates = predicates
#
#     def to_sql(self, table_alias):
#         # todo: need to check if the prop is in neo4j or not
#         # replace the varName with table alias
#         # todo: check what else should be modified regarding the different syntex of different languages
#         sql_predicates = [i.replace(self.var.variable_name, table_alias) for i in self.predicates]
#         return " AND ".join(sql_predicates)

# todo: for return component, the text which is variable property or aggregation function can be from neo4j
#  or postgres, so there is a is_in_neo4j boolean indicator, if it is not in neo4j, need to replace the var name to table
class RelationComponent:
    # the text can be predicates/select or group by component like var.prop
    def __init__(self, var: Variable, text: str, is_in_neo4j: bool):
        self.var = var
        self.text = text
        self.is_in_neo4j = is_in_neo4j

    # check if there is any difference between aggregation functions in cypher and sql
    def to_sql(self, table_alias_map: dict[Variable, Table]) -> str:
        if self.var is None:
            return self.text
        if self.is_in_neo4j:
            return self.text.replace(f"{self.var.variable_name}.", f"neo4j.{self.var.variable_name}")
        table_alias = table_alias_map[self.var].table_alias
        # needs to replace var.prop to table_alias.prop
        # use var_name. instead of var_name so that the name string in other part of the text will not be replaced
        return self.text.replace(f"{self.var.variable_name}.", f"{table_alias}.")


class RelationComponentWithPGProp(RelationComponent):
    def __init__(self, var: Variable, text: str):
        super().__init__(var, text, False)

def split_queries(length: int, train_ratio=0.8):
    """Shuffle and split queries into train and test sets"""
    indices = list(range(length))
    random.shuffle(indices)

    split_point = int(len(indices) * train_ratio)
    train_indices = indices[:split_point]
    test_indices = indices[split_point:]

    return train_indices, test_indices


def remove_stars(query: str):
    # Pattern: matches [:TYPE*] or [:TYPE*x..y] etc.
    pattern = r':(\w+)\*\d*\.*\d*'
    # Replace with single-length version
    return re.sub(pattern, r':\1', query)


def process_node(node_var: str, node_label: str, num_of_filter_table: int,
                 join_with_filter: dict, alias_rels: dict):
    # if it has number, should join with a filter relation
    if re.search(r'\d+', node_label):
        filter_table_name = f"filter_{node_label}"
        filter_table_alias = f"f{num_of_filter_table}"
        num_of_filter_table += 1
        if node_var in join_with_filter:
            print("=======================something went wrong=========================")
        join_with_filter[node_var] = filter_table_alias
        alias_rels[filter_table_alias] = filter_table_name
        node_label = re.sub(r'\d+', '', node_label)
    return node_label, num_of_filter_table


def process_cypher_query(cypher_query: str, edge_relation_map:dict):
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
    var_edge_rels_join_cols = {}
    var_node_rels = {}
    select_predicates = {}
    num_of_edges = 0
    num_of_filter_table = 0
    processed_vars = set()
    # if an entity node has filter for example Author1, Author2 etc, just store the filter table name without cols
    join_with_filter = {}
    matches = re.finditer(EDGE_PATTERN, cypher_query)
    # variable to its label
    var_label = {}
    entity_num = 0

    for match in matches:
        full_path, node1_var, node1_label, edge_label, node2_var, node2_label = match.groups()
        # if it does not have a label, it is matched before
        if node1_label == '':
            node1_label = var_label[node1_var]
        if node2_label == '':
            node2_label = var_label[node2_var]

        # it does not have to be filter by id, if there is cols to be extracted from the table, also need a join
        if node1_var not in processed_vars:
            node1_label, num_of_filter_table = process_node(node1_var, node1_label, num_of_filter_table,
                                                            join_with_filter, alias_rels)
            processed_vars.add(node1_var)
            var_label[node1_var] = node1_label
        else:
            node1_label = var_label[node1_var]

        if node2_var not in processed_vars:
            node2_label, num_of_filter_table = process_node(node2_var, node2_label, num_of_filter_table,
                                                            join_with_filter, alias_rels)
            processed_vars.add(node2_var)
            var_label[node2_var] = node2_label
        else:
            node2_label = var_label[node2_var]

        # get the relations corresponding to the edge
        rel = edge_relation_map[edge_label]
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
        if left_var in var_edge_rels_join_cols:
            path_joins.append((var_edge_rels_join_cols[left_var], left_var_col))
        # else map the variable name to table.col
        else:
            var_edge_rels_join_cols[left_var] = left_var_col

        if right_var in var_edge_rels_join_cols:
            path_joins.append((var_edge_rels_join_cols[right_var], right_var_col))
        else:
            var_edge_rels_join_cols[right_var] = right_var_col

    # get the return clause, check if for each var, it returns id, if so, return the table.col stored in the map
    match = re.search(r'(?i)\bRETURN\b(.*)', cypher_query)
    return_clause = match.group(1).strip()
    return_components = [i.strip() for i in return_clause.split(",")]
    for component in return_components:
        var_alias = [i.strip() for i in re.split(r'(?i)\bAS\b', component)]
        assert len(var_alias) == 2
        var_prop = var_alias[0].split(".")
        var_name = var_prop[0]
        select_prop = var_prop[-1]
        prop_alias = var_alias[1]

        if select_prop != "id" and select_prop != "year" and select_prop != "word":
            # todo: if it has a prop which is not id, then need to extract the prop from the entity table,
            #  if it is already in the join dict, it means it already joins with a filter table
            #  then extract the prop from entity filter table, otherwise need to add a join with entity table
            if var_name not in join_with_filter:
                # add it to join_with_filter
                # need to add an alias name
                alias = f"en{entity_num}"
                entity_num += 1
                # alias_rels[alias] = "openalex_subset." + var_label[var_name]
                alias_rels[alias] = var_label[var_name]
                join_with_filter[var_name] = alias
            select_prop = f"{join_with_filter[var_name]}.{select_prop}"
            select_predicates[prop_alias] = select_prop
        else:
            if var_name not in var_edge_rels_join_cols:
                raise InvalidQueryError("path not detected")
            select_predicates[prop_alias] = var_edge_rels_join_cols[var_name]

    for var_name in join_with_filter:
        # add the node filter join to the path joins, since the node var_name to edge col is defined now
        if var_label[var_name] == "Keyword":
            path_joins.append((join_with_filter[var_name] + ".name", var_edge_rels_join_cols[var_name]))
        else:
            path_joins.append((join_with_filter[var_name]+".id", var_edge_rels_join_cols[var_name]))
    return alias_rels, path_joins, select_predicates


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
    return list(select_component), list([i.lower().lstrip() for i in from_component]), list(where_component)


def cross_model_queries_to_sql(cypher_query: str, sql_query: str, edge_relation_map: dict):
    alias_rels, path_joins, select_predicates = process_cypher_query(cypher_query, edge_relation_map)
    select_component, from_component, where_component = process_sql_query(sql_query)
    sql_select, sql_where = [], []

    for i in select_component:
        if 'neo4j' in i:
            sql_select.append(select_predicates[i.split('.')[-1].strip()].lower())
        else:
            sql_select.append(i.lower())
    from_component.extend([f"{value.lower()} {key.lower()}" for key, value in alias_rels.items()])
    from_component.remove("neo4j")

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
    sql_where.extend([f"{t1.lower()}={t2.lower()}" for (t1, t2) in path_joins])

    return ("SELECT " + ", ".join(sql_select) + "\n" + "FROM " + ", ".join(from_component) + "\n" +
            "WHERE " + " and ".join(sql_where))


def rewrite_cm_queries_to_sql(cm_queries: list[str], edge_relation_map: dict):
    sql_queries = []
    for query in cm_queries:
        print(f"================================== raw cross-model query ================================== \n {query} ")
        crt_cm_query = [i.strip() for i in query.split("**********")]
        if '*' in crt_cm_query[0] or '|' in crt_cm_query[0]:
            sql_queries.append('TODO')
            continue
        if len(crt_cm_query) < 2:
            sql_queries.append('Invalid query TODO')
            continue
        try:
            crt_sql_query = cross_model_queries_to_sql(crt_cm_query[0], crt_cm_query[1], edge_relation_map)
            print(
                f"================================== sql query ================================== \n {crt_sql_query}")
            sql_queries.append(crt_sql_query)
        except InvalidQueryError:
            sql_queries.append('Invalid query TODO')
            continue
    return sql_queries
