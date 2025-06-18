import json
import re
from itertools import chain
import torch
import numpy as np
from abc import ABCMeta, abstractmethod
from collections import deque
from torch_geometric.data import Data

from load_workloads import WorkloadInfo

UNKNOWN_OP_TYPE = "Unknown"
# Neo4j related nodes
AGGREGATION_TYPES = ["EagerAggregation", "OrderedAggregation"]
PATH_EXPAND_TYPES = ["Expand", 'Expand(Into)', 'Expand(All)', 'VarLengthExpand(All)']
JOIN_TYPES = ["Apply", "NodeHashJoin"]
DISTINCT_TYPE = ["OrderedDistinct", "Distinct"]
Neo4j_RELATION_SCAN = "RelationNodeScan"
Neo4j_RELATION_JOIN = "RelationNodeJoin"
CROSS_TYPE = [Neo4j_RELATION_SCAN, Neo4j_RELATION_JOIN]
Neo4j_OP_TYPES = [UNKNOWN_OP_TYPE, "NodeByLabelScan", "ProduceResults", "Filter", "Projection", "Argument", "Sort",
                  "Top", "CacheProperties", "ProduceResult", "Unwind", "Limit", "Union", "Anti", "ProcedureCall"] \
                 + AGGREGATION_TYPES + CROSS_TYPE + PATH_EXPAND_TYPES + JOIN_TYPES + DISTINCT_TYPE

# PG related nodes
RELATION_SCAN = "RelationScan"
RELATION_JOIN = "Join"
PG_OP_TYPES = [UNKNOWN_OP_TYPE, "Neo4jQuery", RELATION_JOIN, RELATION_SCAN, "NodeByLabelScan"]

# LARGE_QUERY_TIME = 10000
# OUT_OF_TIME_QUERY_TIME = 100000


# This is only for encoding the tree's nodes to features.
# The part that encodes the join graph should not be here
# the input_relations/labels include this node's and also this node's children's input relation
class SampleNeo4jEntity:
    def __init__(self, node_type: np.ndarray, card: float, left, right,
                 input_relations: list, encoded_relations: np.ndarray,
                 input_labels: list, encoded_labels: np.ndarray):
        self.node_type = node_type
        self.card = card
        self.left = left
        self.right = right
        # this is for cross model nodes
        self.input_relations = input_relations
        self.encoded_relations = encoded_relations
        # this is for nodeScan nodes
        self.input_labels = input_labels
        self.encoded_labels = encoded_labels
        self.neo4j_tensor = None

    def __str__(self):
        return "{%s, %s, [%s], [%s], [%s], [%s], [%s], [%s]}" % (
            self.node_type, self.card, self.left, self.right,
            self.input_relations, self.encoded_relations, self.input_labels, self.encoded_labels)

    def get_feature(self):
        return np.hstack((self.node_type, np.array([self.card]),
                          np.array(self.encoded_labels), np.array(self.encoded_relations)))

    def get_left(self):
        return self.left

    def get_right(self):
        return self.right

    def subtrees(self):
        trees = []
        trees.append(self)
        if self.left is not None:
            trees += self.left.subtrees()
        if self.right is not None:
            trees += self.right.subtrees()
        return trees


class SamplePGEntity:
    def __init__(self, node_type: np.ndarray, encoded_relations: np.ndarray, encoded_labels: np.ndarray,
                 left_card: float, right_card: float):
        self.node_type = node_type
        self.encoded_relations = encoded_relations
        self.encoded_labels = encoded_labels
        self.left_card = left_card
        self.right_card = right_card

    def __str__(self):
        return "{%s, [%s], [%s], [%s], [%s]}" % (
            self.node_type, self.encoded_relations, self.encoded_labels, self.left_card, self.right_card)

    # this will be called to get the features of each node in GNN
    def get_node_feature(self):
        return np.hstack((self.node_type, np.array(self.left_card), np.array(self.right_card),
                          np.array(self.encoded_relations), np.array(self.encoded_labels)))


# (Data, SampleNeo4jEntity)
class SingleFeature:
    def __init__(self, pg_feature: Data, neo4j_feature: SampleNeo4jEntity):
        self.pg_feature = pg_feature
        self.neo4j_feature = neo4j_feature


class PGPlanNode:
    def __init__(self, node_type: str, input_relation: list, input_label: list):
        self.node_type = node_type
        self.input_relation = input_relation
        self.input_label = input_label

    def __str__(self) -> str:
            return "%s (relation %s label %s)" % (self.node_type, self.input_relation, self.input_label)


class PlanNode:
    def __init__(self, node_type: str, estimated_cardinality, input_cardinality: list = None, input_label: str = None,
                 identifiers: list = None, input_relation: str = None, node_id: int = None,
                 is_right_child: bool = False, filter_predicates: list = None) -> None:
        self.node_type = node_type
        self.var_name = None
        # self.left_id = None
        # self.right_id = None
        # self.parent_id = None
        self.estimated_cardinality = estimated_cardinality
        self.input_cardinality = list(input_cardinality) if input_cardinality else None
        self.label_name = input_label
        self.relation_name = input_relation
        self.identifiers = list(identifiers) if identifiers else None
        self.left = None
        self.right = None
        self.parent = None
        self.is_root = False
        self.is_right_child = is_right_child
        self.node_id = node_id
        self.filter_predicates = filter_predicates

    def __str__(self) -> str:
        return "%s (estimated cardinality=%f)" % (self.node_type, self.estimated_cardinality)

    def single_node_copy(self):
        new_node = PlanNode(self.node_type, self.estimated_cardinality, self.input_cardinality,
                            self.label_name, self.identifiers, self.relation_name, self.node_id, self.is_right_child)
        new_node.is_root = self.is_root
        return new_node

    def deepcopy(self, parent=None):
        root = self.single_node_copy()
        root.parent = parent

        if self.left:
            root.left = self.left.deepcopy(root)
            if self.right:
                root.right = self.right.deepcopy(root)
        return root


class PlanParser:

    def __init__(self, json_obj: dict):
        self.plan = json_obj

    def plan_parse_helper(self, json_obj: dict, level: int, visualize=False) -> PlanNode:
        ope_type_with_db = json_obj['operatorType']
        operator_type = ope_type_with_db.split("@")[0]
        root = PlanNode(operator_type, json_obj['args']["EstimatedRows"])
        if visualize:
            print("  " * level, "->", root)
        if 'identifiers' in json_obj:
            vars_array = json_obj['identifiers']
            root.identifiers = [str(x) for x in vars_array]
        if operator_type == "NodeByLabelScan":
            var_label = json_obj['args']['Details'].split(":")
            root.label_name = var_label[1]
            root.var_name = var_label[0]
        # todo: should the filter predicates also be considered in feature generator
        #  is there just one label can be in filter?
        if operator_type == "Filter":
            predicates = [i.strip() for i in json_obj['args']['Details'].split("AND")]
            root.filter_predicates = predicates
            var_names, labels = process_filter_node(predicates)
            if len(labels) == 1:
                root.var_name = var_names[0]
                root.label_name = labels[0]
        if 'children' in json_obj:
            if len(json_obj['children']) == 1:
                left_node = self.plan_parse_helper(json_obj['children'][0], level + 1, visualize)
                left_node.parent = root
                root.left = left_node
            elif len(json_obj['children']) == 2:
                left_node = self.plan_parse_helper(json_obj['children'][0], level + 1, visualize)
                left_node.parent = root
                root.left = left_node
                right_node = self.plan_parse_helper(json_obj['children'][1], level + 1, visualize)
                right_node.parent = root
                root.right = right_node
                right_node.is_right_child = True
            else:
                assert len(json_obj['children']) == 0
        return root

    # there can be variables with the same name, so can not just use the variable name
    # todo: Some variables do not have name, I did not store the modified queries
    # todo: needs to have a function that get the node for each variable instead of for each label
    # There are two possibilities to match a node:
    # 1. NodeByLabelScan
    # 2. Filter: if it is filter, parse the args.detail, find the varName:varLabel pattern and if the varName
    # is not like 'anon'
    def plan_parse_simple(self, visualize=False) -> (PlanNode, dict):
        root = self.plan_parse_helper(self.plan, 0, visualize)
        root.is_root = True
        nodes = level_traverse(root)
        node_name_2_node_id = {}
        node_id = 0
        for n in nodes:
            n.node_id = node_id
            # if this is a nodel by label scan node
            if n.node_type == 'NodeByLabelScan':
                # if n.var_name not in node_name_2_node_id:
                node_name_2_node_id[n.var_name] = node_id
            if n.node_type == 'Filter':
                predicates = n.filter_predicates
                var_names, var_labels = process_filter_node(predicates)
                for i in range(len(var_names)):
                    name = var_names[i]
                    # label = var_labels[i]
                    # if not name.startswith("anon") and label not in node_name_2_node_id:
                    if not name.startswith("anon"):
                        node_name_2_node_id[name] = node_id
            node_id += 1
        return root, node_name_2_node_id

    def get_node_by_label_scan(self, visualize=False) -> set[str]:
        root = self.plan_parse_helper(self.plan, 0, visualize)
        root.is_root = True
        nodes = level_traverse(root)
        node_vars = set()
        for n in nodes:
            if n.node_type == 'NodeByLabelScan':
                node_vars.add(n.var_name)
        return node_vars
# for each workload, get the raw cypher plan and variables mapping


def transform_neo4j_plans(raw_plans):
    plans = []
    for tree in raw_plans:
        plan_parser = PlanParser(tree)
        plan, name2node = plan_parser.plan_parse_simple()
        plans.append((plan, name2node))
    return plans


def level_traverse(root: PlanNode) -> list[PlanNode]:
    assert root.is_root

    q = deque()
    q.append(root)

    visit_res = []
    while len(q) > 0:
        curr_node = q.popleft()
        visit_res.append(curr_node)
        if curr_node.left is not None:
            q.append(curr_node.left)
        if curr_node.right is not None:
            q.append(curr_node.right)
    return visit_res


class PlanModifier:

    def __init__(self, raw_plan: PlanNode, name2node: dict, join_plan: dict, relation_size: dict):
        self.raw_plan = raw_plan.deepcopy()
        self.name2node_id = name2node
        self.join_plan = join_plan
        self.relation_size = relation_size
        self.node_id2node = {}

    def node_id_mapping(self, root: PlanNode):
        # traverse the plan tree to get the id node mapping
        self.node_id2node[root.node_id] = root
        if root.left:
            self.node_id_mapping(root.left)
            if root.right:
                self.node_id_mapping(root.right)

    # todo: will it modify the raw neo4j plan object?
    def modify_tree(self):
        # create relation scan node type with relation name and cross join node type
        self.node_id_mapping(self.raw_plan)
        for var in self.join_plan:
            relation_name = self.join_plan[var]
            # get the node that first match the label
            raw_node = self.node_id2node[self.name2node_id[var]]
            raw_parent = raw_node.parent
            # create - raw_parent
            #           -- relation_join node
            #               --- relation scan node
            #               --- raw node
            assert relation_name in self.relation_size
            relation_join_node = PlanNode(Neo4j_RELATION_JOIN, 0,
                                          input_cardinality=[raw_node.estimated_cardinality,
                                                             self.relation_size[relation_name]],
                                          input_label=raw_node.label_name,
                                          input_relation=relation_name)
            relation_scan_node = PlanNode(Neo4j_RELATION_SCAN, self.relation_size[relation_name],
                                          input_relation=relation_name)
            if raw_node.is_right_child:
                raw_parent.right = relation_join_node
                relation_join_node.is_right_child = True
            else:
                raw_parent.left = relation_join_node
            relation_join_node.left = relation_scan_node
            relation_join_node.right = raw_node
            raw_node.is_right_child = True


# this will modify the neo4j plan part
# todo: the fit is training the generator using the training data,
#  then transform uses the training generator to do the transform
class FeatureGenerator:
    # the raw plans is a list of json files, each json file is the raw plan for the raw Neo4j query
    # the join_dicts are relations and variables that needs to be joined in the workload
    # the all_plans are a list of dictionaries with variables and tables to be passed to neo4j
    def __init__(self) -> None:
        self.normalizer = None
        self.feature_parser = None
        # self.raw_plans = [i.cypher_plan for i in workloads]
        # self.join_dicts = [i.join_dict for i in workloads]
        # self.all_plans = [i.all_plans for i in workloads]
        # self.all_exe_times = [i.all_exe_times for i in workloads]
        # self.relation_size = relation_size
        # self.raw_plan_trees = []
        # self.relations = set()

    # traverse all the json plans and join dictionaries of the training workloads
    # to get the normalizer, relations, node labels and node_types
    def fit(self, workloads: list[WorkloadInfo], relation_size: dict):
        raw_plans = [i.cypher_plan for i in workloads]
        join_dicts = [i.join_dict for i in workloads]
        # all_plans = [i.all_plans for i in workloads]
        all_exe_times = [i.all_exe_times for i in workloads]
        relations = set()
        node_labels = set()
        node_type = set()
        estimated_rows = []
        execution_times = list(chain(*all_exe_times))

        # recurse all the plan json files to get all the estimated rows, node labels, node types etc
        def recurse(n):
            estimated_rows.append(n["args"]["EstimatedRows"])
            ope_type_with_db = n['operatorType']
            operator_type = ope_type_with_db.split("@")[0]
            node_type.add(operator_type)
            if operator_type == "NodeByLabelScan":
                # todo: if a variable does not have a name, the split may not work
                node_labels.add(n['args']['Details'].split(":")[1])
            # todo: process Filter node
            if operator_type == "Filter":
                _, labels = process_filter_node([i.strip() for i in n['args']['Details'].split("AND")])
                node_labels.update(labels)
            if "children" in n:
                for child in n["children"]:
                    recurse(child)

        for json_plan in raw_plans:
            # assert len(tree_and_rel) == 3
            # # json_plan is the neo4j plan, join_rels are relations to be passed to the
            # # neo4j db, and there should be a global list that stores all the other relations
            # json_plan = tree_and_rel[0]
            # join_rels = tree_and_rel[1]
            # execution_times.append(tree_and_rel[2])

            recurse(json_plan)
        # get all relations in the workloads
        for i in join_dicts:
            relations.update(list(i.values()))
        relation_sizes = [relation_size[i] for i in relations]
        # add relation sizes to estimated rows
        estimated_rows.extend(relation_sizes)
        relation_sizes = np.array(relation_sizes)
        estimated_rows = np.array(estimated_rows)
        execution_times = np.array(execution_times)

        relation_sizes = np.log(relation_sizes + 1)
        estimated_rows = np.log(estimated_rows + 1)
        execution_times = np.log(execution_times + 1)

        relation_sizes_min = np.min(relation_sizes)
        relation_sizes_max = np.max(relation_sizes)
        estimated_rows_min = np.min(estimated_rows)
        estimated_rows_max = np.max(estimated_rows)
        execution_times_min = np.min(execution_times)
        execution_times_max = np.max(execution_times)

        # todo: relation size is for the relational join encoding, execution time is for the final label
        self.normalizer = Normalizer({"Estimated Card": estimated_rows_min,
                                      "Execution Time": execution_times_min,
                                      "Relation Size": relation_sizes_min},
                                     {"Estimated Card": estimated_rows_max,
                                      "Execution Time": execution_times_max,
                                      "Relation Size": relation_sizes_max}
                                     )
        self.feature_parser = AnalyzePlanNode(self.normalizer, list(relations), relation_size, list(node_labels))

    # modify the raw json plan tree based on the relations passed to it
    # todo: should modify in the future, now for one label, there can only be one variable joined,
    #  so the var2nodeid stores label to node id, and I use the label name as relation name, so I only need to pass a
    #  set of relation names to the gnn feature extraction, should modify this: should store var name to node mapping
    #  what if the node is not scanned, how to modify
    def transform(self, workloads, relation_size) -> (list[list[SingleFeature]], list[list]):
        features = []
        labels = []

        raw_plans = [i.cypher_plan for i in workloads]
        join_dicts = [i.join_dict for i in workloads]
        all_plans = [i.all_plans for i in workloads]
        all_exe_times = [i.all_exe_times for i in workloads]
        # parse the raw neo4j plan
        raw_plan_trees = transform_neo4j_plans(raw_plans)

        for i in range(len(raw_plan_trees)):
            # for each workload, get the raw plan and for all join plans, modify the raw plan
            crt_raw_plan = raw_plan_trees[i][0]
            crt_name_2_node_id = raw_plan_trees[i][1]
            all_tables = set(join_dicts[i].values())
            # show all the join plans for a single workload
            crt_join_plans = all_plans[i]
            crt_exe_times = all_exe_times[i]
            assert len(crt_join_plans) > 1
            crt_features = []
            crt_labels = []
            for j in range(len(crt_join_plans)):
                join_plan = crt_join_plans[j]
                exe_time = crt_exe_times[j]
                if exe_time == 0.0:
                    print("check error")
                # for each plan, modify the tree, then get the graph query features and the GNN features
                plan_modifier = PlanModifier(crt_raw_plan, crt_name_2_node_id, join_plan, relation_size)
                plan_modifier.modify_tree()
                # visualize_tree(plan_modifier.raw_plan, 0)
                rest_tables = all_tables - set(join_plan.values())
                # should pass the rest of relations to the extract_feature function
                crt_features.append(self.feature_parser.extract_feature(plan_modifier.raw_plan, rest_tables))
                crt_labels.append(self.normalizer.norm(exe_time, "Execution Time"))
            features.append(crt_features)
            labels.append(crt_labels)
        return features, labels


class Normalizer:
    def __init__(self, mins: dict, maxs: dict) -> None:
        self._mins = mins
        self._maxs = maxs

    def norm(self, x, name):
        if name not in self._mins or name not in self._maxs:
            raise Exception("fail to normalize " + name)

        return (np.log(x + 1) - self._mins[name]) / (self._maxs[name] - self._mins[name])

    def inverse_norm(self, x, name):
        if name not in self._mins or name not in self._maxs:
            raise Exception("fail to inversely normalize " + name)

        return np.exp((x * (self._maxs[name] - self._mins[name])) + self._mins[name]) - 1

    def replace_with_max(self, x, name):
        if name not in self._maxs:
            raise Exception("fail to normalize " + name)
        return self._maxs[name]

    def contains(self, name):
        return name in self._mins and name in self._maxs


class FeatureEmbedding(metaclass=ABCMeta):
    @abstractmethod
    def extract_feature(self, plan: PlanNode, join_dict: dict) -> SingleFeature:
        pass


class AnalyzePlanNode(FeatureEmbedding):

    def __init__(self, normalizer: Normalizer, relations: list, relations_stats: dict, labels: list) -> None:
        self.normalizer = normalizer
        self.relations = relations
        self.relation_size = relations_stats
        self.labels = labels

    # the join dict is a dictionary with variable name as key and relation name as value
    # todo: for now, assume that there is only one variable per label to be joined
    #  so there is only relation names needed
    def extract_gnn_feature(self, root: SampleNeo4jEntity, rels: set) -> Data:
        # node_features = []
        edge_index = []
        nodes = []
        nodes_for_vis = []
        # node feature is [node type, cardinality, encoded relations]
        neo4j_node = SamplePGEntity(op_to_one_hot("Neo4jQuery", False),
                                    root.encoded_relations, root.encoded_labels, root.card, 0)
        nodes.append(neo4j_node)
        nodes_for_vis.append(PGPlanNode("Neo4jQuery", root.input_relations, root.input_labels))
        # node_features.append(neo4j_node.get_node_feature())
        node_id = 0
        for rel in rels:
            # crt_label = join_dict[rel]
            rel_size = self.relation_size[rel]
            relation_scan_node = SamplePGEntity(op_to_one_hot(RELATION_SCAN, False), self.encode_relation_names([rel]),
                                                self.encode_label_names([]), rel_size, 0)
            node_scan = SamplePGEntity(op_to_one_hot("NodeByLabelScan", False), self.encode_relation_names([]),
                                       self.encode_label_names([rel]), root.card, 0)
            relation_join_node = SamplePGEntity(op_to_one_hot(RELATION_JOIN, False), self.encode_relation_names([rel]),
                                                self.encode_label_names([rel]), rel_size, root.card)
            nodes.append(relation_scan_node)
            nodes.append(node_scan)
            nodes.append(relation_join_node)
            nodes_for_vis.append(PGPlanNode(RELATION_SCAN, [rel], []))
            nodes_for_vis.append(PGPlanNode("NodeByLabelScan", [], [rel]))
            nodes_for_vis.append(PGPlanNode(RELATION_JOIN, [rel], [rel]))

            # relation scan to relation join
            edge_index.append([node_id + 1, node_id + 3])
            # neo4j query to node scan
            edge_index.append([0, node_id + 2])
            # node scan to relation join
            edge_index.append([node_id + 2, node_id + 3])
            node_id = node_id + 3

        # visualize_graph(nodes_for_vis, edge_index)
        node_features = [np.array(i.get_node_feature()) for i in nodes]
        return Data(torch.tensor(np.array(node_features)), torch.tensor(edge_index, dtype=torch.long).t().contiguous())

    def extract_plan_tree_feature(self, root: PlanNode) -> SampleNeo4jEntity:
        left = None
        right = None
        input_relations = []
        input_labels = []

        # this means has child
        if root.left is not None:
            left = self.extract_plan_tree_feature(root.left)
            input_relations += left.input_relations
            input_labels += left.input_labels

            if root.right is not None:
                right = self.extract_plan_tree_feature(root.right)
                input_relations += right.input_relations
                input_labels += right.input_labels
            else:
                right = SampleNeo4jEntity(op_to_one_hot(UNKNOWN_OP_TYPE), 0, None, None, [],
                                          self.encode_relation_names([]), [], self.encode_label_names([]))
        node_type = op_to_one_hot(root.node_type)
        card = self.normalizer.norm(root.estimated_cardinality, 'Estimated Card')

        if root.relation_name is not None:
            input_relations.append(root.relation_name)
        if root.label_name is not None:
            input_labels.append(root.label_name)
        return SampleNeo4jEntity(node_type, card, left, right, input_relations,
                                 self.encode_relation_names(input_relations),
                                 input_labels, self.encode_label_names(input_labels))

    # extracting features for both pg part and neo4j plan part
    def extract_feature(self, plan: PlanNode, join_dict_in_rel: set) -> SingleFeature:
        tree_plan = self.extract_plan_tree_feature(plan)
        gnn_feature = self.extract_gnn_feature(tree_plan, join_dict_in_rel)
        return SingleFeature(gnn_feature, tree_plan)

    # todo: the relations should include all relations not just relations passed to Neo4j
    def encode_relation_names(self, l):
        encode_arr = np.zeros(len(self.relations) + 1)

        for name in l:
            if name not in self.relations:
                # -1 means UNKNOWN
                encode_arr[-1] += 1
            else:
                encode_arr[list(self.relations).index(name)] += 1
        return encode_arr

    # todo: the labels should include all labels including labels in the pg join graph
    def encode_label_names(self, labels: list[str]):
        encode_arr = np.zeros(len(self.labels) + 1)

        for name in labels:
            if name not in self.labels:
                # -1 means UNKNOWN
                encode_arr[-1] += 1
            else:
                encode_arr[list(self.labels).index(name)] += 1
        return encode_arr


def op_to_one_hot(op_name, isNeo4j=True):
    if isNeo4j:
        arr = np.zeros(len(Neo4j_OP_TYPES))
        if op_name not in Neo4j_OP_TYPES:
            print(op_name)
            arr[Neo4j_OP_TYPES.index(UNKNOWN_OP_TYPE)] = 1
        else:
            arr[Neo4j_OP_TYPES.index(op_name)] = 1
        return arr
    else:
        arr = np.zeros(len(PG_OP_TYPES))
        if op_name not in PG_OP_TYPES:
            print(op_name)
            arr[PG_OP_TYPES.index(UNKNOWN_OP_TYPE)] = 1
        else:
            arr[PG_OP_TYPES.index(op_name)] = 1
        return arr


def process_filter_node(predicates: list[str]) -> (list[str], list[str]):
    pattern = r"^([^:\W]*):([^:\s\W]+)$"
    # get var names and labels in filter predicates
    var_names = []
    var_labels = []
    for p in predicates:
        match = re.match(pattern, p)
        if match:
            var_name = match.group(1)
            var_label = match.group(2)
            var_names.append(var_name)
            var_labels.append(var_label)
    return var_names, var_labels


def visualize_tree(root: PlanNode, level):
    print("  " * level, "->", root)
    if root.left is not None:
        visualize_tree(root.left, level + 1)
    if root.right is not None:
        visualize_tree(root.right, level + 1)


def visualize_graph(nodes: list[PGPlanNode], edges: list):
    for i in range(len(edges)):
        edge = edges[i]
        node1 = nodes[edge[0]]
        node2 = nodes[edge[1]]
        print(node1, "->", node2)


def get_pairs(x: list[SingleFeature], y: list) -> (list[SingleFeature], list[SingleFeature], list, list):
    assert len(x) >= 2
    assert len(x) == len(y)
    x1, x2, y1, y2 = [], [], [], []
    for i in range(len(x)):
        for j in range(i + 1, len(x)):
            x1.append(x[i])
            x2.append(x[j])
            y1.append(y[i])
            y2.append(y[j])
    return x1, x2, y1, y2


# generate pairwise comparison, this will not keep the workload information, just a bunch of binary comparison
def get_pairwise_plan(features: list[list[SingleFeature]], labels: list[list]) \
        -> (list[SingleFeature], list[SingleFeature], list, list):
    assert len(features) == len(labels)
    f1, f2, l1, l2 = [], [], [], []
    for i in range(len(features)):
        # for each workload, generate pairwise comparisons
        crt_features = features[i]
        crt_labels = labels[i]
        if len(crt_features) == 1:
            continue
        crt_f1, crt_f2, crt_l1, crt_l2 = get_pairs(crt_features, crt_labels)
        f1 += crt_f1
        f2 += crt_f2
        l1 += crt_l1
        l2 += crt_l2
    return f1, f2, l1, l2


def get_pointwise_plan(features: list[list[SingleFeature]], labels: list[list]) -> (list[SingleFeature], list):
    f, l = [], []
    for i in features:
        f.extend(i)
    for i in labels:
        l.extend(i)
    return f, l


if __name__ == '__main__':
    # todo: test the feature generator
    with open('testfiles/test.json', 'r') as file:
        json_str = file.read()
    parse = json.loads(json_str)
    trees = [[parse, {"m": "r", "message": "s"}, 20]]
    feature_gen = FeatureGenerator()
    feature_gen.fit({"r": 100, "e": 500, "s": 300})
    X = feature_gen.transform({"r": 100, "e": 500, "s": 300})

    X[0].get_feature()
