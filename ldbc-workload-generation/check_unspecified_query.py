# for unspecified query, check if it is >= 1 or < 1
# for correct unspecified query, add it to the correct query file, and rewrite it to cross model queries
from utils.neo4jutils import Neo4jUtil

if __name__ == '__main__':
    unspecified_cypher_path = r"C:\Users\sauzh\Documents\Work\crossmodel\workloads\unspecified_error.cypher"
    with open(unspecified_cypher_path, 'r') as file:
        cypher_str = file.read()
    cypher_queries = [i.strip() for i in cypher_str.split(";")]
    # for each query, check the cardinality
    uri = "bolt://localhost:7687"
    user = "neo4j"
    db_name = "test"
    password = "1996AHtc!"
    neo4j_util = Neo4jUtil(uri, user, password, db_name)
    correct_queries = []
    for query in cypher_queries:
        estimated_card = neo4j_util.verify_correctness(query)
        if estimated_card == 1.0:
            print(query)
            correct_queries.append(query)
    print(len(correct_queries))
    with open(r'C:\Users\sauzh\Documents\Work\crossmodel\workloads\correct_llm.cypher', 'a') as file:
        file.write(';\n' + ';\n'.join(correct_queries))
