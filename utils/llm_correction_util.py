import re
import regex as rex
from enum import Enum, auto

from utils.neo4jutils import Neo4jUtil


class ErrorType(Enum):
    # NO_ERROR = auto()
    SYNTAX_ERROR = auto()  # error 1
    NON_EXISTING_EDGE_TYPE = auto()  # error 2
    WRONG_EDGE_DIR = auto()  # error 3
    WRONG_EDGE_TYPE_FOR_SPECIFIC_NODES = auto()  # error 4
    UNDEFINED_ERROR = auto()  # error 5


def read_and_process_llm_queries(queries_file: str) -> list[str]:
    queries = []
    with open(queries_file, 'r') as file:
        queries_content = file.read()
    # some queries are separated by ; and some are enclosed by ```
    enclosed_queries = []
    enclosed_match = [(m.start(), m.end()) for m in re.finditer(r'```(.+?)```', queries_content, flags=re.DOTALL)]
    for i in enclosed_match[::-1]:
        enclosed_queries.append(queries_content[i[0]:i[1]])
        queries_content = queries_content[:i[0]] + queries_content[i[1]:]
    # process enclosed queries
    for q_str in enclosed_queries:
        qs = [i.strip().lstrip("cypher") for i in q_str.split(";")]
        for q in qs:
            q = q.strip('`')
            # find the first occurrence of match and extract the content from it till the end
            match = re.search(r"MATCH\s", q)
            if match:
                queries.append(q[match.start():])
    # process other queries
    other_queries = [i.strip() for i in queries_content.split(";")]
    for q in other_queries:
        match = re.search(r"MATCH\s", q)
        if match:
            queries.append(q[match.start():])
    return queries


# get the labels for all variables with names
def get_variable_labels(query) -> dict:
    """
    get a mapping from variable names to the labels of the vars
    :param query: cypher query
    :return: dict from var names to var labels
    """
    var_pattern = re.compile(r'(\w+|\s*)\s*:(\w+)')
    matches = var_pattern.finditer(query)
    vars_labels = {}
    for match in matches:
        var_name = match.group(1)
        var_label = match.group(2)
        if var_name != '':
            vars_labels[var_name] = var_label
    # for variable from collect, it will be a list of the element variable type
    # todo: there can be more patterns
    with_patterns = [r'WITH\s+(?:DISTINCT\s+)?(\w+)\s+AS\s+(\w+)',
                     r'\((\w+)\)\s+AS\s+(\w+)']
    # idx, parent_var, children var
    with_matches = []
    for pat in with_patterns:
        matches = re.finditer(pat, query, re.IGNORECASE)
        for match in matches:
            with_matches.append([match.start(), match.group(1), match.group(2)])
    # order the with_matches by the start index
    with_matches = sorted(with_matches, key=lambda x: x[0])
    for match in with_matches:
        if match[1] in vars_labels:
            vars_labels[match[2]] = vars_labels[match[1]]
    # for variables from unwind, it should inherit the label of its parent variable
    var_unwind_pattern = re.compile(r'unwind\s+(\w+)\s+as\s+(\w+)', re.IGNORECASE)
    unwind_matches = var_unwind_pattern.finditer(query)
    for match in unwind_matches:
        vars_labels[match.group(2)] = vars_labels[match.group(1)]
    return vars_labels


def get_node_label(node_name_label, vars_labels):
    if ":" in node_name_label:
        return node_name_label.split(":")[-1].strip()
    else:
        if node_name_label not in vars_labels:
            print(f"variable label not found for: {node_name_label}")
            return None
        return vars_labels[node_name_label]


def modify_edge(forward_dir: bool, edge_text: str) -> str:
    if forward_dir:
        modified_dir = re.sub(r'-\[(.*?)\]->', r'<-[\1]-', edge_text)
    else:
        modified_dir = re.sub(r'<-\[(.*?)\]-', r'-[\1]->', edge_text)
    return modified_dir


def correct_query_edges(query, relationships):
    """
    Find some edge-related errors:
    1. The edge type does not exist: NON_EXISTING_EDGE_TYPE
    2. The edge direction is wrong and can be corrected: WRONG_EDGE_DIR
    3. The edge type does not exist between certain pair of nodes: WRONG_EDGE_TYPE_FOR_SPECIFIC_NODES
    4. Unspecified error
    For WRONG_EDGE_DIR, correct the query and return the corrected query
    :param query: llm-generated cypher query
    :param relationships: a mapping from relationship type to a pair of node labels
    :return: a set of error types, a corrected query. If the query can not be corrected, then return None
    """
    vars_labels = get_variable_labels(query)
    edge_pattern = r'\((\w*\s*\:?\w*)\s*(?:\{.*?\})?\s*\)<?-\[(\w*\s*\:\w*\d*\s*)\s*(?:\{.*?\})?\*?\d?\.?\.?\d?\s*\]->?\((\w*\s*:?\w*)\s*(?:\{.*?\})?\s*\)'
    # edge_pattern = r'\((\w*\s*\:?\w*)\s*(?:\{.*?\})?\s*\)<?-\[(\w*\s*\:\w*\s*)\s*(?:\{.*?\})?\s*\]->?\((\w*\s*:?\w*)\s*(?:\{.*?\})?\s*\)'
    replacements = []
    error_types = set()
    # rex can find overlapping patterns, so use it instead of re
    edges = rex.finditer(edge_pattern, query, overlapped=True)
    for edge in edges:
        if ">" in edge.group(0):
            forward_dir = True
        elif "<" in edge.group(0):
            forward_dir = False
        else:
            # print(f"edge with no direction: {edge.group(0)}")
            continue
        edge_name_type = edge.group(2)
        edge_type = edge_name_type.split(":")[-1].strip()
        if edge_type not in relationships:
            error_types.add(ErrorType.NON_EXISTING_EDGE_TYPE)
            continue
        crt_relationships = relationships[edge_type]

        if forward_dir:
            left_node = edge.group(1)
            right_node = edge.group(3)
        else:
            left_node = edge.group(3)
            right_node = edge.group(1)

        left_label = get_node_label(left_node, vars_labels)
        right_label = get_node_label(right_node, vars_labels)
        if left_label is None and right_label is None:
            continue
        if left_label is None or right_label is None:
            print(f"************\nonly one side label: {query}\n************")
            crt_left_labels = set([i[0] for i in crt_relationships])
            crt_right_labels = set([i[1] for i in crt_relationships])
            if left_label is None:
                tgt_label = right_label
                crt_labels = crt_right_labels
                crt_other_labels = crt_left_labels
            else:
                tgt_label = left_label
                crt_labels = crt_left_labels
                crt_other_labels = crt_right_labels
            if tgt_label not in crt_labels:
                if tgt_label in crt_other_labels:
                    error_types.add(ErrorType.WRONG_EDGE_DIR)
                    replacements.append((edge.group(0), modify_edge(forward_dir, edge.group(0))))
                else:
                    error_types.add(ErrorType.WRONG_EDGE_TYPE_FOR_SPECIFIC_NODES)
        elif (left_label, right_label) not in crt_relationships:
            if (right_label, left_label) in crt_relationships:
                error_types.add(ErrorType.WRONG_EDGE_DIR)
                print(f"wrong edge but corrected: {edge.group(0)}")
                replacements.append((edge.group(0), modify_edge(forward_dir, edge.group(0))))
            else:
                error_types.add(ErrorType.WRONG_EDGE_TYPE_FOR_SPECIFIC_NODES)
    for r in replacements:
        query = query.replace(r[0], r[1])
    # if there is only wrong direction error, then correct the query and return
    if len(error_types) == 1 and ErrorType.WRONG_EDGE_DIR in error_types:
        return error_types, query
    return error_types, None


def categorize_llm_queries(neo4j_util: Neo4jUtil, queries: list[str], relationship_map: dict):
    correct_queries = []  # queries with no syntax or semantic error
    error1_queries = []  # query nums for queries have syntax errors
    error2_queries = []  # NON_EXISTING_EDGE_TYPE
    error3_queries = []  # WRONG_EDGE_DIR
    error3_only_queries = []
    error4_queries = []  # WRONG_EDGE_TYPE_FOR_SPECIFIC_NODES
    # there are two types of unspecified error queries, 1. no other errors detected
    # 2. for error 3 only queries, even if the directions are corrected, the cardinality is still small
    error5_queries = []
    # for error 3 only queries, after correcting edge directions, they have large cardinalities,
    # append both query num and corrected query
    corrected_queries = []

    for i in range(len(queries)):
        q = queries[i]
        try:
            card = neo4j_util.verify_correctness(q)
        except Exception as e:
            error1_queries.append(i)
            print(e)
            continue
        # print the estimated cardinality of the original query
        print(f"Query has cardinality {card}")
        # # if the estimated cardinality is relatively large, then just directly add it to correct query
        # if card > 2:
        #     print("Query is syntax and semantic correct")
        #     correct_queries.append(i)
        #     continue
        # if the cardinality is small, need to analyze what kind of error there is
        errors, new_q = correct_query_edges(q, relationship_map)
        # if there is no error but estimated card is small, then there is unspecified error
        if len(errors) == 0:
            if card < 2:
                error5_queries.append((i, q))
            else:
                print("Query is syntax and semantic correct")
                correct_queries.append(i)
        # if there are specific errors and not just edge direction errors
        elif new_q is None:
            for err in errors:
                if err == ErrorType.NON_EXISTING_EDGE_TYPE:
                    error2_queries.append(i)
                elif err == ErrorType.WRONG_EDGE_DIR:
                    error3_queries.append(i)
                elif err == ErrorType.WRONG_EDGE_TYPE_FOR_SPECIFIC_NODES:
                    error4_queries.append(i)
        # if there is corrected query, it means there is only edge direction err
        else:
            error3_only_queries.append(i)
            error3_queries.append(i)
            new_card = neo4j_util.verify_correctness(new_q)
            print(f"Corrected query has new cardinality {new_card}")
            if new_card > 2:
                corrected_queries.append((i, new_q))
            else:
                # if there is only edge direction error, but after correction, the estimated card is small, there
                # must be unspecified error.
                error5_queries.append((i, new_q))
    return (correct_queries, error1_queries, error2_queries, error3_queries,
            error3_only_queries, error4_queries, error5_queries, corrected_queries)


def categorize_queries(neo4j_util: Neo4jUtil, queries: list[str], extended_relationship_map: dict, output_prefix: str):
    """
    For llm generated queries, categorize them to different types. Print the number of queries in each category
    :param queries: clean llm queries
    :param extended_relationship_map: an extended version of relationships between nodes
    :param neo4j_util: neo4j connection and query util
    :param output_prefix: the file prefix of output files
    """
    # read queries from the file, process it and restore it to a new file
    # queries = read_and_process_llm_queries(queries_file)
    # with open(output_prefix + 'clean_llm.cypher', 'w') as file:
    #     file.write(';\n'.join(queries))

    (correct_queries, error1_queries, error2_queries, error3_queries, error3_only_queries, error4_queries,
     error5_queries, corrected_queries) = categorize_llm_queries(neo4j_util, queries, extended_relationship_map)

    # queries that are correct or are corrected after fixing edge directions
    all_correct_queries = [queries[i] for i in correct_queries] + [i[1] for i in corrected_queries]

    # store the query seq of the queries with different types of errors
    # with open(output_prefix + 'error1.cypher', 'w') as file:
    #     file.write('\n'.join([queries[i] for i in error1_queries]))

    # store correct and corrected queries to file
    with open(output_prefix + 'correct_llm.cypher', 'w') as file:
        file.write(';\n'.join(all_correct_queries))

    with open(output_prefix + 'syntax_error.cypher', 'w') as file:
        file.write('\n######\n'.join([queries[i] for i in error1_queries]))

    with open(output_prefix + 'non_existing_edge.cypher', 'w') as file:
        file.write('\n'.join([queries[i] for i in error2_queries]))

    with open(output_prefix + 'wrong_edge_dir.cypher', 'w') as file:
        file.write('\n'.join([queries[i] for i in error3_queries]))

    with open(output_prefix + 'wrong_edge_type.cypher', 'w') as file:
        file.write(';\n'.join([queries[i] for i in error4_queries]))

    # with open(output_prefix + 'error5_idx.txt', 'w') as file:
    #     file.write('\n'.join(str(i[0]) for i in error5_queries))
    with open(output_prefix + 'unspecified_error.cypher', 'w') as file:
        file.write(';\n'.join([i[1] for i in error5_queries]))

    print(f"There are {len(correct_queries)} correct queries\n")
    print(f"There are {len(error1_queries)} queries with syntax error\n")
    print(f"There are {len(error2_queries)} queries with NON_EXISTING_EDGE_TYPE error\n")
    print(f"There are {len(error3_queries)} queries with WRONG_EDGE_DIR error\n")
    print(f"There are {len(error3_only_queries)} queries with only WRONG_EDGE_DIR error\n")
    print(f"There are {len(error4_queries)} queries with WRONG_EDGE_TYPE_FOR_SPECIFIC_NODES error\n")
    print(f"There are {len(error5_queries)} queries with UNSPECIFIED error\n")
    print(f"There are {len(corrected_queries)} queries corrected after fixing WRONG_EDGE_DIR error\n")
