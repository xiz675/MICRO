"""
The workloads are split into many files, each file is run and
Take the evaluation_results for each workload, and concatenate them to get all the evaluation_results

"""
import json
import os

from sklearn.model_selection import train_test_split


def filter_valid_plans(all_plans: list) -> list:
    return [[i for i in workload if i['time'] > 0] for workload in all_plans]


# store workloads info
def store_workloads(all_plans, workloads, raw_plans, base_dir, idx_list=None):
    if idx_list is not None:
        all_plans = [all_plans[i] for i in idx_list]
        workloads = [workloads[i] for i in idx_list]
        raw_plans = [raw_plans[i] for i in idx_list]
    with open(base_dir+"all_plans_with_runtime.json", 'w') as out:
        json.dump(all_plans, out)
    with open(base_dir+"workloads.json", 'w') as out:
        json.dump(workloads, out)
    with open(base_dir+"cypher_raw_plans.json", 'w') as out:
        json.dump(raw_plans, out)


# todo: check the workloads which have error, if there are not many, maybe just remove them
# todo: just read the all the training part, but I am not sure if I should consider all test workloads,
# maybe remove the workloads which are todo in the garlic/xdb


def concatenate_json_arrays(files) -> list:
    # read json file and create json objects
    json_data = []
    for file in files:
        content = read_json_file(file)
        json_data.extend(content)
        for i in range(len(content)):
            if len(content[i]) == 0:
                print("===========================")
                print(file)
                print(i)
    return json_data


def extract_info(all_plans_file, raw_plans_file, workloads_file):
    plans, r_plans, wls = read_json_file(all_plans_file), read_json_file(raw_plans_file), read_json_file(workloads_file)
    # if a workload has 0 plan, then should not get its raw plan, and should remove the workload from plans
    wl_idx = [i for i in range(len(plans)) if len(plans[i]) > 0]
    if len(wl_idx) < len(plans):
        print(all_plans_file)
    return [plans[i] for i in wl_idx], [r_plans[i] for i in wl_idx], wls


def concatenate_data(path: str, output_path: str):
    """
    each directory contains all_plans_with_run_time.json,  cypher_raw_plans.json and workloads.json
    contains all the files in all the directories in the given path for each of the three files
    :param path: directory where files reside in
    :param output_path: base directory to write the evaluation_results to
    :return:
    """
    # all_plans_files = []
    # workloads_files = []
    # raw_plans_files = []
    all_valid_plans_json, workloads_json, raw_plans_json = [], [], []
    for f in os.scandir(path):
        if not f.is_dir():
            continue
        all_plans_file, raw_plans_file, workloads_file = None, None, None
        for file in os.scandir(f.path):
            if file.is_file():
                # get all files under each sub-dir
                file_name = file.name
                if "all_plans" in file_name:
                    all_plans_file = file.path
                    # todo: remove the workloads where the number of plans are empty
                if "raw_plans" in file_name:
                    raw_plans_file = file.path
                if "workloads" in file_name:
                    workloads_file = file.path
        crt_all_plans, crt_raw_plans, crt_workloads = extract_info(all_plans_file, raw_plans_file, workloads_file)

        # remove plans with execution time 0
        crt_valid_plans = filter_valid_plans(crt_all_plans)
        # todo: after removing, if any workload has 0 valid plan, should remove that workload
        all_valid_plans_json.extend(crt_valid_plans)
        workloads_json.extend(crt_workloads)
        raw_plans_json.extend(crt_raw_plans)
    assert len(all_valid_plans_json) == len(workloads_json) == len(raw_plans_json)
    for i in range(len(workloads_json)):
        crt_plans = all_valid_plans_json[i]
        crt_times = [plan['time'] for plan in crt_plans]
        if any(time >= 10000 for time in crt_times):
            wl = workloads_json[i]
            print(wl)
            # rp = raw_plans_json[i]
            # print(rp)
    # train_idx, test_idx = train_test_split(range(len(all_valid_plans_json)), test_size=0.2, random_state=42)
    # training_dir = output_path + "/train/"
    # test_dir = output_path + "/test/"
    store_workloads(all_valid_plans_json, workloads_json, raw_plans_json, output_path)
    # store_workloads(all_valid_plans_json, workloads_json, raw_plans_json, test_idx, test_dir)


def concatenate_txt_files(files, output_file):
    # read files in and write out files and "\n" for separation
    with open(output_file, 'w') as out:
        for file in files:
            with open(file, 'r') as infile:
                content = infile.read()
                out.write(content)


def read_json_file(file) -> list:
    with open(file, 'r') as infile:
        crt_json = json.load(infile)
        print(len(crt_json))
    return crt_json



    # with open(output_file, 'w') as out:
    #     json.dump(json_data, out)




# todo: after concatenating all execution evaluation_results, split them into training and test folder
# def split_workloads_train_test(workloads: list[WorkloadInfo]):
#     # randomly split into train and test dataset
#     train_idx, test_idx = train_test_split(range(len(workloads)), test_size=0.2, random_state=42)
#     train_workloads = [workloads[i] for i in train_idx]
#     test_workloads = [workloads[i] for i in test_idx]
#     return train_workloads, test_workloads


# read all the workloads and their
if __name__ == '__main__':
    path = r'C:/Users/sauzh/Documents/Work/crossmodel/workloads/results/sf1/t1/small-trains/'
    # path = r'C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/result/small-trains/'
    # out_path = r'C:\Users\sauzh\Documents\Work\crossmodel\splitted-evaluation_results'
    # todo: modify the execution time for large query or query without output
    # todo: read the index file to get training and test
    concatenate_data(path, path)
