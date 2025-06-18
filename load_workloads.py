import json
import random


class WorkloadInfo:
    def __init__(self, cypher_plan: json, join_dict: dict, all_plans: list[dict], all_exe_times: list):
        self.cypher_plan = cypher_plan
        # what tables are joined with what labels
        self.join_dict = join_dict
        self.all_plans = all_plans
        self.all_exe_times = all_exe_times


# this is for loading the raw neo4j plan
# each line is a neo4j plan
def _load_raw_neo4j_plan(path):
    with open(path, 'r') as file:
        loaded_data = json.load(file)
    return [json.loads(plan) for plan in loaded_data]


# load the join dictionary from JSON file. {variable name: relation (col) name}
# each element is a join dict
def _load_join_info(path):
    with open(path, 'r') as file:
        loaded_data = json.load(file)
    return [{entry[0].split(".")[0]: entry[-1] for entry in inner_list} for inner_list in loaded_data]


def _load_all_plans(path):
    """
    Load the multiple queries' plans and times from a JSON file, where each query contains
    plans and their corresponding times.

    :param path: Path to the file containing the serialized plans and times.
    :return: A tuple containing two lists:
             - plans: A list of lists of dict (var: table_label).
             - times: A list of lists of times.
    """
    with open(path, 'r') as file:
        deserialized_data = json.load(file)

    # Extract the plans and times
    # todo: needs to figure out what is the key and value in the plans dict, should the value be the
    #  table variable name or label name (real label or the parent label)?
    plans = [[{entry[0].split(".")[0]: entry[-1] for entry in plan_time['plan']}
              for plan_time in query_plans] for query_plans in deserialized_data]
    times = [[plan_time['time'] for plan_time in query_plans] for query_plans in deserialized_data]

    return plans, times


# load the join dictionary from JSON file. {variable name: relation (col) name}
# each line is a join dict
def _load_rel_stats(path):
    with open(path, 'r') as file:
        loaded_data = json.load(file)
    return loaded_data


def prepare_input(prefix: str, num_of_queries=None) -> (list[WorkloadInfo], dict):
    """
    The function takes the input path of the training file, generates the pairwise training data,
    X1: featurize plans 1
    X2: featurize plans 2
    Y1: execution times for plans1
    Y2: execution times for plans2
    It
    """
    workloads = []
    neo4j_plans = _load_raw_neo4j_plan(prefix + "/cypher_raw_plans.json")
    join_dicts = _load_join_info(prefix + "/workloads.json")
    all_plans, all_exe_times = _load_all_plans(prefix + "/all_plans_with_runtime.json")
    all_relations_stats = _load_rel_stats(prefix + "/rel_stats.json")
    if num_of_queries is not None:
        # todo: random select some workloads
        chosen_indices = random.sample(range(len(neo4j_plans)), num_of_queries)
        neo4j_plans = [neo4j_plans[i] for i in chosen_indices]
        join_dicts = [join_dicts[i] for i in chosen_indices]
        all_plans = [all_plans[i] for i in chosen_indices]
        all_exe_times = [all_exe_times[i] for i in chosen_indices]

    assert len(neo4j_plans) == len(join_dicts) == len(all_plans) == len(all_exe_times)
    for i in range(len(neo4j_plans)):
        crt_workload = WorkloadInfo(neo4j_plans[i], join_dicts[i], all_plans[i], all_exe_times[i])
        workloads.append(crt_workload)
    return workloads, all_relations_stats


# for a single workload, generate the pairwise comparison

