# load the model and predicate for new workloads
import argparse
import json
import time

from crossmodel import LeroModelCrossModels, LeroModel
from features import get_pairwise_plan, transform_neo4j_plans, PlanParser
from load_workloads import prepare_input, WorkloadInfo
import numpy as np


def get_min_indices(lst, n=3):
    # Sort indices by corresponding values in lst, and take the first n indices
    return sorted(range(len(lst)), key=lambda i: lst[i])[:n]


def get_plan_from_moved_rels(plans: list[dict], moved_rels: set) -> int:
    chosen_plan_idx = 0
    max_joined_vars = 0
    for i in range(len(plans)):
        plan = plans[i]
        rels = set(plan.values())
        if rels == moved_rels:
            if len(plan) > max_joined_vars:
                chosen_plan_idx = i
    return chosen_plan_idx


def baseline_table_size(test_workloads: list[WorkloadInfo], rel_stats, threshold=1000) -> list[int]:
    # for each workload, get the joined relations, and move all relations smaller than a threshold
    # raw_plans = [i.cypher_plan for i in test_workloads]
    join_dicts = [i.join_dict for i in test_workloads]
    all_plans = [i.all_plans for i in test_workloads]
    # all_exe_times = [i.all_exe_times for i in test_workloads]

    all_rels = [set(i.values()) for i in join_dicts]
    moved_rels = [set([rel for rel in rels if rel_stats[rel] <= threshold]) for rels in all_rels]

    # given the moved rels, get the plans that use all the rels, a moved table set can correspond to multiple var joins,
    # choose the large one
    # all_plans_moved_rels = []
    chosen_plans_idx = []
    for i in range(len(all_plans)):
        crt_plans = all_plans[i]
        crt_moved_rels = moved_rels[i]
        chosen_plans_idx.append(get_plan_from_moved_rels(crt_plans, crt_moved_rels))
    return chosen_plans_idx


def baseline_first_visit_nodes(test_workloads: list[WorkloadInfo]) -> list[int]:
    raw_plans = [i.cypher_plan for i in test_workloads]
    join_dicts = [i.join_dict for i in test_workloads]
    all_plans = [i.all_plans for i in test_workloads]

    chosen_plans_idx = []

    for i in range(len(raw_plans)):
        plan_parser = PlanParser(raw_plans[i])
        node_vars = plan_parser.get_node_by_label_scan()
        join_vars = join_dicts[i]
        moved_join_vars = node_vars.intersection(join_vars)
        move_table = False
        crt_plans = all_plans[i]
        for j in range(len(crt_plans)):
            if set(crt_plans[j].keys()) == moved_join_vars:
                chosen_plans_idx.append(j)
                move_table = True
                break
        if not move_table:
            print("check error")
    return chosen_plans_idx


def baseline_degree(test_workloads: list[WorkloadInfo], node_degree: dict, threshold=5):
    # todo: for workloads variables, if the corresponding nodes have an average degree larger than a threshold
    join_dicts = [i.join_dict for i in test_workloads]
    all_plans = [i.all_plans for i in test_workloads]
    chosen_plans_idx = []
    for i in range(len(all_plans)):
        crt_plans = all_plans[i]
        workload = join_dicts[i]
        crt_moved_rels = set([workload.values() for key in workload if node_degree[key] > threshold])
        chosen_plans_idx.append(get_plan_from_moved_rels(crt_plans, crt_moved_rels))
    return chosen_plans_idx


def baseline_regression(test_workloads: list[WorkloadInfo], rel_stats, model_path) -> list[int]:
    lero_regression = LeroModel(None)
    lero_regression.load(model_path)
    features, labels = lero_regression.feature_generator.transform(test_workloads, rel_stats)
    predictions = [lero_regression.predict(i) for i in features]
    return [np.argmin(i) for i in predictions]


def cmlero_result(test_workloads: list[WorkloadInfo], rel_stats, model_path) -> list[int]:
    st = time.time()
    # load the model, and get the workloads
    lero = LeroModelCrossModels(None)
    lero.load(model_path)
    features, labels = lero.feature_generator.transform(test_workloads, rel_stats)
    predictions = [lero.predict(i) for i in features]
    print(f"prediction costs {time.time() - st}")
    # get tables in each plan, if the plan has table with size larger than a threshold, then set the value as large
    # for i in range(len(test_workloads)):
    #     crt_plans = test_workloads[i].all_plans
    #     for j in range(len(crt_plans)):
    #         tables = set(crt_plans[j].values())
    #         bad_plan = False
    #         for t in tables:
    #             if rel_stats[t] > threshold:
    #                 bad_plan = True
    #                 break
    #         if bad_plan:
    #             predictions[i][j] = np.inf
    chosen_plans = [np.argmin(i) for i in predictions]
    x1, x2, y1, y2 = get_pairwise_plan(features, labels)
    # lero.evaluate(x1, x2, y1, y2)
    return chosen_plans


# todo: return top k hit rate, q error and average q error
def evaluate(workloads: list[WorkloadInfo], chosen_plans: list[int], test_idx: list[int] = None):
    if test_idx is not None:
        workloads = [workloads[i] for i in test_idx]
        chosen_plans = [chosen_plans[i] for i in test_idx]

    # get the top 5 plans
    all_exe_times = [i.all_exe_times for i in workloads]
    best_plan_idices = [get_min_indices(i, n=3) for i in all_exe_times]
    best_exe_times = [np.min(i) for i in all_exe_times]
    good_plans_workloads = [i for i in range(len(chosen_plans)) if chosen_plans[i] in best_plan_idices[i]]
    chosen_plan_exe_times = [all_exe_times[i][chosen_plans[i]] for i in range(len(chosen_plans))]
    # get the hit rate
    hr = 1.0 * len(good_plans_workloads) / len(workloads)
    # get q error, get the percentile of q-errors
    q_errors = [chosen_plan_exe_times[i] / best_exe_times[i] for i in range(len(workloads))]
    q_errors_percentile = []
    for percentile in [50, 90, 95, 99, 100]:
        q_errors_percentile.append(np.percentile(q_errors, percentile))
    # get the normalized execution time ratio, average of the q-error
    # todo: these two are different, should modify it
    avg_q_error = np.average(q_errors)
    return hr, q_errors, q_errors_percentile, avg_q_error, chosen_plan_exe_times, best_exe_times


# filter out test workloads
def filter_test_workloads(test_workloads: list[WorkloadInfo], threshold: float):
    exe_times_std = [np.std(i.all_exe_times) for i in test_workloads]
    return [i for i in range(len(test_workloads)) if exe_times_std[i] > threshold]


def evaluate_all_methods(workloads: list[WorkloadInfo], model_results: dict, test_idx: list[int] = None, result_path = '.'):
    evaluate_results = {}
    for model in model_results:
        chosen_index = model_results[model]
        hit_rate, q_err, q_err_per, q_err_avg, chosen_plan_time, best_exec_time = evaluate(workloads, chosen_index, test_idx)
        chosen_index = [chosen_index[i] for i in test_idx]

        # store the chosen plan index and time
        with open(f"{result_path}/{model}-chosen-plan.txt", "w") as f:
            for i in range(len(chosen_plan_time)):
                f.write(f"{chosen_index[i]}, {chosen_plan_time[i]}, {q_err[i]}, {best_exec_time[i]} \n")
        if test_idx is not None:
            print(f"""Evaluate partial results on {len(test_idx)} workloads""")
        else:
            print(f"""Evaluate results on all workloads""")
        print(f"""{model} has hit rate {hit_rate}, average of q_err is {q_err_avg}, total time is {sum(chosen_plan_time)}""")
        percentiles = [50, 90, 95, 99, 100]
        for i in range(len(percentiles)):
            print(f"""      q-error {percentiles[i]}% percentile is {q_err_per[i]}""")
        print(sum(chosen_plan_time[-12:]))


def read_degree_json(node_degree_path):
    # Loading JSON file back into a dictionary
    with open(node_degree_path, "r") as json_file:
        loaded_data = json.load(json_file)
    return loaded_data


if __name__ == '__main__':
    # load the files
    parser = argparse.ArgumentParser("Model evaluation helper")
    parser.add_argument('--model-path', dest='model_path', type=str, required=True)
    parser.add_argument('--test-data', dest='test_data', type=str, required=True)
    parser.add_argument("--node-degree-path", dest='node_degree_path', type=str, required=False)
    parser.add_argument("--result-path", dest='result_path', type=str, required=True)

    args = parser.parse_args()
    regular_query = args.test_data + "/test"
    var_length_query = args.test_data + "/test-var"
    test_workloads, rel_stats = prepare_input(regular_query)
    test_workloads2, _ = prepare_input(var_length_query)
    test_workloads.extend(test_workloads2)
    x = [test_workloads[i].all_exe_times[0] for i in range(len(test_workloads))]
    # remove_idx = [i for i in range(len(x)) if x[i]>=10000]

    predicate_results = {"baseline1": baseline_table_size(test_workloads, rel_stats, threshold=10000),
                         "baseline2": baseline_first_visit_nodes(test_workloads)
                         }
    # # for each baseline and our method, should get the top n plan index, then evaluate them together
    #
    # # read degree from json file
    # # node_degrees = read_degree_json(args.node_degree_path)
    # # predicate_results["baseline3"] = baseline_degree(test_workloads, node_degrees)
    #
    model_name = args.model_path
    predicate_results["baseline-pointwise"] = baseline_regression(test_workloads, rel_stats, f"""{model_name}-point""")
    predicate_results["cmlero"] = cmlero_result(test_workloads, rel_stats, f"""{model_name}-pair""")

    # try different training size to test how the performance change for different models when training size varies
    for num_of_queries in [100, 150, 200, 250, 300]:
        predicate_results[f"""baseline-pointwise-{num_of_queries}"""] = baseline_regression(test_workloads, rel_stats, f"""{model_name}-point-{num_of_queries}""")
        predicate_results[f"""cmlero-{num_of_queries}"""] = cmlero_result(test_workloads, rel_stats, f"""{model_name}-pair-{num_of_queries}""")
    # #
    evaluate_all_methods(test_workloads, predicate_results, result_path=args.result_path)

    remove_idx = []
    evaluate_idx = [i for i in range(len(test_workloads)) if i not in remove_idx]