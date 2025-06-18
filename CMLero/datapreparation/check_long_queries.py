import os

from datapreparation.output_concat import read_json_file


def print_long_queries(path: str):
    """
    return each directories long-run query index
    """
    for f in os.scandir(path):
        if f.is_dir():
            for file in os.scandir(f.path):
                if file.is_file():
                    # get all files under each sub-dir
                    file_name = file.name
                    if "all_plans" in file_name:
                        # get all workloads all plans execution times, if any time is large for a workload, return it
                        crt_workloads = read_json_file(file.path)
                        crt_times = [[plan['time'] for plan in workload] for workload in crt_workloads]
                        print("===========================")
                        for workload_idx in range(len(crt_times)):
                            if any(time >= 10000 for time in crt_times[workload_idx]):
                                print(f.name)
                                print(workload_idx)
                                print(crt_times[workload_idx])
    # # remove plans with execution time 0
    # all_plans_json = concatenate_json_arrays(all_plans_files)
    # all_valid_plans_json = filter_valid_plans(all_plans_json)
    # workloads_json = concatenate_json_arrays(workloads_files)
    # raw_plans_json = concatenate_json_arrays(raw_plans_files)
    # for i in range(len(workloads_json)):
    #     crt_plans = all_valid_plans_json[i]
    #     crt_times = [plan['time'] for plan in crt_plans]
    #     if any(time >= 10000 for time in crt_times):
    #         wl = workloads_json[i]
    #         print(wl)
    #         rp = raw_plans_json[i]
    #         print(rp)
    # assert len(all_valid_plans_json) == len(workloads_json) == len(raw_plans_json)


if __name__ == '__main__':
    path = r'C:\Users\sauzh\Documents\Work\crossmodel\results\sf10-d1'
    # out_path = r'C:\Users\sauzh\Documents\Work\crossmodel\splitted-evaluation_results'
    # todo: modify the execution time for large query or query without output
    print_long_queries(path)