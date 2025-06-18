import os
import re
from pathlib import Path

if __name__ == '__main__':
    cross_model_query_path = r"C:\Users\sauzh\Documents\Work\crossmodel\workloads\gpt-wo-agg-new\cross-model-query"
    sql_query_dir = r"C:\Users\sauzh\Documents\Work\crossmodel\workloads\gpt-wo-agg-new\sql-query"
    total_invalid_count = 0
    for f in os.scandir(sql_query_dir):
        file_name = f.name
        with open(f.path, 'r') as file:
            queries = file.read()
        split_queries = [i for i in re.split(r';+', queries) if i != ""]
        corresponding_query_path = Path(os.path.join(cross_model_query_path, file_name)).with_suffix(".txt")
        with open(corresponding_query_path, 'r') as file:
            cm_queries = file.read()
        split_cm_queries = [i.strip() for i in cm_queries.split("##########") if i != ""]
        assert len(split_cm_queries) == len(split_queries)
        for i in range(len(split_queries)):
            if 'TODO' in split_queries[i]:
                total_invalid_count += 1
                print("=========")
                print(file_name)
                print(i)
                print(split_cm_queries[i])
    print("==========================")
    print(total_invalid_count)

