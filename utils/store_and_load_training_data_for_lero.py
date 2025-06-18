import json


# store neo4j raw plans, store join dicts, store relation stats
def store_json_list(path, json_list):
    with open(path, 'w') as file:
        json.dump(json_list, file, indent=4)


def store_all_plans(path, times, plans):
    """
    Store the plans and corresponding times in a file.

    :param path: Path to store the plan runtime.
    :param plans: [plans_1, plans_2, ..., plans_n], plans_i = [plans_i1, plans_i2, ..., plans_im];
                    plans_ij = [tuple_1, tuple_2, ..., tuple_k]. Each tuple is (var.prop, table_var.col, glabel, tlabel).
    :param times: A list of lists of floats representing the runtime of each plan.
    """
    # Combine the plans and times into a serialized structure
    serialized_data = [[{'plan': plans[i][j], 'time': times[i][j]} for j in range(len(plans[i]))]
                       for i in range(len(plans))]

    # Store the serialized data in JSON format
    with open(path, 'w') as file:
        json.dump(serialized_data, file, indent=4)

    print(f"Plans with runtime successfully written to {path}")


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
    plans = [[{entry[0].split(".")[0]: entry[-1].split(".")[0] for entry in plan_time['time']}
              for plan_time in query_plans] for query_plans in deserialized_data]
    times = [[plan_time['plan'] for plan_time in query_plans] for query_plans in deserialized_data]

    return plans, times
