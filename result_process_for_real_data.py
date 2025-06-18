import json

from utils.sql_parser_util import SQLParser


def read_cm_queries(f: str):
    with open(f, 'r') as file:
        queries = file.read()
    all_queries = [i.strip() for i in queries.split("##########") if i != ""]
    sql_queries = [q.strip().split('**********')[1].strip() for q in all_queries]
    return sql_queries


def get_relation_names(query: str) -> dict:
    # parse the sql query to get the mapping from alias to table real name
    sql_info = SQLParser(query).parser()
    return sql_info.from_mapping


def read_json_file(file) -> list:
    with open(file, 'r') as infile:
        crt_json = json.load(infile)
        print(len(crt_json))
    return crt_json


def read_workloads_and_plans(all_plans_file: str, workloads_file: str):
    return read_json_file(all_plans_file),  read_json_file(workloads_file)


def modify_workloads_plans(workload: list[list], all_plans: list[dict], mapping: dict):
    for join_element in workload:
        join_element.append(mapping[join_element[3]])
    for plan in all_plans:
        crt_plan = plan["plan"]
        for i in crt_plan:
            i.append(mapping[i[3]])


if __name__ == '__main__':
    # read all the directories under a center a path, read the
    # result_path = f"C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/with_index_result/test1"
    # query_path = f"C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/result/test/all_test.txt"

    for i in range(32):
        result_path = f"C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/with_index_result/small-trains/all_train_{i}"
        query_path = f"C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/result/small-trains-queries/small-trains/all_train_part_{i}.txt"
        sql_queries = read_cm_queries(query_path)
        sql_mappings = [get_relation_names(i) for i in sql_queries]
        plans, wls = read_workloads_and_plans(result_path+"/all_plans_with_runtime.json", result_path+"/workloads.json")
        assert len(sql_mappings) == len(plans) == len(wls)
        [modify_workloads_plans(wls[i], plans[i], sql_mappings[i]) for i in range(len(sql_mappings))]
        with open(result_path + "/new_all_plans_with_runtime.json", 'w') as out:
            json.dump(plans, out)
        with open(result_path + "/new_workloads.json", 'w') as out:
            json.dump(wls, out)


    # sql_queries = read_cm_queries(query_path)
    # sql_mappings = [get_relation_names(i) for i in sql_queries]
    # plans, wls = read_workloads_and_plans(result_path+"/all_plans_with_runtime.json", result_path+"/workloads.json")
    # # plans = plans[:-1]
    # # wls = wls[:-1]
    # assert len(sql_mappings) == len(plans) == len(wls)
    # [modify_workloads_plans(wls[i], plans[i], sql_mappings[i]) for i in range(len(sql_mappings))]
    # with open(result_path + "/new_all_plans_with_runtime.json", 'w') as out:
    #     json.dump(plans, out)
    # with open(result_path + "/new_workloads.json", 'w') as out:
    #     json.dump(wls, out)


