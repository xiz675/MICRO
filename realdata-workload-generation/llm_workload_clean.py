# todo: remove the property filter such as  {word: "Deep Learning"}
# queries = read_and_process_llm_queries(path_prefix + query_path)
# with open(path_prefix + 'clean_llm.cypher', 'w') as file:
#     file.write(';\n'.join(queries))
# preprocess the llm generated queries to get clean llm
import re

from utils.llm_correction_util import read_and_process_llm_queries

if __name__ == '__main__':
    path_prefix = r"C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/"
    query_path = "llm.cypher"
    queries = read_and_process_llm_queries(path_prefix + query_path)
    # with open(path_prefix + 'clean_llm.cypher', 'w') as file:
    #     file.write(';\n'.join(queries))
    # with open(path_prefix + query_path, 'r') as file:
    #     cypher_str = file.read()
    # queries = cypher_str.split(";")
    clean_queries = [re.sub(r'(\(\s*\w+\s*:\s*\w+)\s*\{[^}]*\}', r'\1', i) for i in queries]
    with open(path_prefix + 'clean_llm_wo_predicates.cypher', 'w') as file:
        file.write(';\n'.join(clean_queries))
