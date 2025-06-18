import os
from datetime import time

from torch_geometric.data import Batch
from torch_geometric.nn import Sequential, global_mean_pool
from torch_geometric.nn import GraphConv
import joblib
import torch
import torch.nn as nn
import numpy as np
from torch.utils.data import DataLoader

from features import SampleNeo4jEntity, FeatureGenerator, SingleFeature

from neo4jPlanEmbedding.TreeConvolution.tcnn import (BinaryTreeConv, DynamicPooling,
                                                     TreeActivation, TreeLayerNorm)
from neo4jPlanEmbedding.TreeConvolution.util import prepare_trees

CUDA = True
GPU_LIST = [0]

#if CUDA:
#    torch.set_default_tensor_type(torch.cuda.DoubleTensor)
#    device = torch.device("cuda:0")
#else:
#    torch.set_default_tensor_type(torch.DoubleTensor)
#    device = torch.device("cpu")
#torch.set_default_dtype(torch.float32)
# torch.set_default_tensor_type(torch.DoubleTensor)
device = torch.device("cuda:0" if CUDA else "cpu")


# these are for storing and loading models
def _nn_path(base):
    return os.path.join(base, "_nn_weights")


def _feature_generator_path(base):
    return os.path.join(base, "feature_generator")


# todo: check if I need two feature generators
def _pg_feature_generator_path(base):
    return os.path.join(base, "pg_feature_generator")


def _neo4j_feature_generator_path(base):
    return os.path.join(base, "neo4j_feature_generator")


def _pg_input_feature_dim_path(base):
    return os.path.join(base, "pg_input_feature_dim")


def _neo4j_input_feature_dim_path(base):
    return os.path.join(base, "neo4j_input_feature_dim")


def neo4j_transformer(x: SampleNeo4jEntity):
    return x.get_feature()


def neo4j_left_child(x: SampleNeo4jEntity):
    return x.get_left()


def neo4j_right_child(x: SampleNeo4jEntity):
    return x.get_right()


def collate_fn(x: list[SingleFeature]):
    graphs, trees = [], []
    for fet in x:
        graphs.append(fet.pg_feature)
        trees.append(fet.neo4j_feature)
    graph_batch = Batch.from_data_list(graphs)
    return graph_batch, trees


def collate_pointwise_fn(x: list[tuple[SingleFeature, float]]):
    graphs, trees, labels = [], [], []
    for fet, label in x:
        fet.pg_feature.x = fet.pg_feature.x.float()
        graphs.append(fet.pg_feature)
        trees.append(fet.neo4j_feature)
        labels.append(label)
    labels = torch.tensor(labels, dtype=torch.float32)
    graph_batch = Batch.from_data_list(graphs)
    return graph_batch, trees, labels


# todo: maybe change it to geometric's own DataLoader
def collate_pairwise_fn(x: list[tuple[SingleFeature, SingleFeature, float]]):
    """
    :param x: a list of lists, each inner list has three parts,
    the first part is SingleFeature, second part is SingleFeature, and the third part is the label
    each tuple has two parts: first part is Graph Data object and the second part is Neo4jEntity
    :return: 4 batched data
    """
    graph1, graph2, tree1, tree2, labels = [], [], [], [], []
    for data1, data2, label in x:
        data1.pg_feature.x = data1.pg_feature.x.float()
        data2.pg_feature.x = data2.pg_feature.x.float()
        graph1.append(data1.pg_feature)
        graph2.append(data2.pg_feature)
        tree1.append(data1.neo4j_feature)
        tree2.append(data2.neo4j_feature)
        labels.append(label)
    # Batch graph data
    graph1_batch = Batch.from_data_list(graph1)
    graph2_batch = Batch.from_data_list(graph2)
    labels = torch.tensor(labels, dtype=torch.float32)
    # return graphs, trees, labels
    return graph1_batch, graph2_batch, tree1, tree2, labels


class LeroNetCrossModels(nn.Module):
    def __init__(self, pg_input_feature_dim, neo4j_input_feature_dim, batch_size) -> None:
        super(LeroNetCrossModels, self).__init__()
        self.pg_input_feature_dim = pg_input_feature_dim
        self.neo4j_input_feature_dim = neo4j_input_feature_dim
        self._cuda = False
        self.device = None
        self.batch_size = batch_size
        self.pg_gnn_net = Sequential('x, edge_index, batch',
                                     [(GraphConv(self.pg_input_feature_dim, 16), 'x, edge_index -> x'),
                                      nn.ReLU(inplace=True),
                                      nn.Dropout(p=0.3),
                                      (GraphConv(16, 16), 'x, edge_index -> x'),
                                      nn.ReLU(inplace=True),
                                      nn.Dropout(p=0.3),
                                      (global_mean_pool, 'x, batch -> x'),
                                      nn.Linear(16, 1),
                                      ])
        self.neo4j_tree_conv = nn.Sequential(
            BinaryTreeConv(self.neo4j_input_feature_dim, 32),
            TreeLayerNorm(),
            TreeActivation(nn.LeakyReLU()),
            BinaryTreeConv(32, 16),
            TreeLayerNorm(),
            DynamicPooling(),
            nn.Linear(16, 8),
            nn.LeakyReLU(),
            nn.Linear(8, 1)
        )
        # Add a linear layer to combine the outputs of net1 and net2
        self.weights = nn.Parameter(torch.tensor([0.5, 0.5], requires_grad=True))
        self.linear = nn.Linear(2, 1)

    def forward(self, pg_graph: Batch, neo4j_trees):
        """
        :param pg_graph: it is graph batch
        :param neo4j_trees: it is a list of trees (SampleNeo4jEntity)
        :return:
        """
        pg_output = self.pg_gnn_net(pg_graph.x, pg_graph.edge_index, pg_graph.batch)
        neo4j_output = self.neo4j_tree_conv(neo4j_trees)
        weighted_pg_output = self.weights[0] * pg_output
        weighted_neo4j_output = self.weights[1] * neo4j_output
        cross_model_result = self.linear(torch.cat((weighted_pg_output, weighted_neo4j_output), dim=1))
        return cross_model_result

    # prepare trees for modified neo4j plans
    def build_trees(self, feature: list[SampleNeo4jEntity]):
        return prepare_trees(feature, neo4j_transformer, neo4j_left_child, neo4j_right_child, cuda=self._cuda,
                             device=self.device)

    def cuda(self, device):
        self._cuda = True
        self.device = device
        return super().cuda()


class LeroModel():
    def __init__(self, feature_generator) -> None:
        self._net = None
        self._feature_generator = feature_generator
        self._pg_input_feature_dim = None
        self._neo4j_input_feature_dim = None
        self._model_parallel = None
        self.batch_size = None

    # todo: check if this is right (future work)
    def load(self, path):
        with open(_pg_input_feature_dim_path(path), "rb") as f:
            self._pg_input_feature_dim = joblib.load(f)
        with open(_neo4j_input_feature_dim_path(path), "rb") as f:
            self._neo4j_input_feature_dim = joblib.load(f)

        self._net = LeroNetCrossModels(self._pg_input_feature_dim, self._neo4j_input_feature_dim, self.batch_size)

        # Load the model state
        if CUDA:
            state_dict = torch.load(_nn_path(path))
        else:
            state_dict = torch.load(_nn_path(path), map_location=torch.device('cpu'))

        # Remove 'module.' prefix if necessary
        state_dict = {k.replace('module.', ''): v for k, v in state_dict.items()}
        print(state_dict.keys())
        self._net.load_state_dict(state_dict)


        if CUDA:
            self._net.load_state_dict(torch.load(_nn_path(path)))
        else:
            self._net.load_state_dict(torch.load(
                _nn_path(path), map_location=torch.device('cpu')))

        self._net.eval()

        with open(_feature_generator_path(path), "rb") as f:
            self._feature_generator = joblib.load(f)

    def save(self, path):
        os.makedirs(path, exist_ok=True)

        if CUDA:
            torch.save(self._net.state_dict(), _nn_path(path))
        else:
            torch.save(self._net.state_dict(), _nn_path(path))

        with open(_pg_input_feature_dim_path(path), "wb") as f:
            joblib.dump(self._pg_input_feature_dim, f)
        with open(_neo4j_input_feature_dim_path(path), "wb") as f:
            joblib.dump(self._neo4j_input_feature_dim, f)

        # store the pg features and neo4j features
        with open(_feature_generator_path(path), "wb") as f:
            joblib.dump(self._feature_generator, f)
        # todo: check should I save batch size

    def fit(self, X: list[SingleFeature], Y, pre_training=False):
        if isinstance(Y, list):
            Y = np.array(Y)
            Y = Y.reshape(-1, 1)
        # determine the initial number of channels for pg graph and for neo4j tree
        pg_input_feature_dim = X[0].pg_feature.x.size(1)
        print("postgres plan graph input_feature_dim:", pg_input_feature_dim)

        neo4j_input_feature_dim = len(X[0].neo4j_feature.get_feature())
        print("neo4j plan tree input_feature_dim:", neo4j_input_feature_dim)

        batch_size = 32

        self._net = LeroNetCrossModels(pg_input_feature_dim, neo4j_input_feature_dim, batch_size)
        self._pg_input_feature_dim = pg_input_feature_dim
        self._neo4j_input_feature_dim = neo4j_input_feature_dim
        self.batch_size = batch_size

        if CUDA:
            self._net = self._net.cuda(device)
            # self._net = torch.nn.DataParallel(self._net, device_ids=GPU_LIST)
            self._net.cuda(device)
            batch_size = batch_size * len(GPU_LIST)

        tuples = [[X[i], Y[i]] for i in range(len(X))]

        # collate_fn gets the batches for training
        dataset = DataLoader(tuples,
                             batch_size=batch_size,
                             shuffle=True,
                             collate_fn=collate_pointwise_fn)

        optimizer = None
        if CUDA:
            optimizer = torch.optim.Adam(self._net.parameters())
            # optimizer = nn.DataParallel(optimizer, device_ids=GPU_LIST)
        else:
            optimizer = torch.optim.Adam(self._net.parameters())

        loss_fn = torch.nn.MSELoss()
        losses = []
        start_time = time()
        for epoch in range(100):
            loss_accum = 0
            for graph_batch, tree_batch, labels in dataset:
                if CUDA:
                    graph_batch = graph_batch.to(device)
                    labels = labels.to(device)

                tree = self._net.build_trees(tree_batch)

                y_pred = self._net(graph_batch, tree)
                loss = loss_fn(y_pred, labels)
                loss_accum += loss.item()

                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

            loss_accum /= len(dataset)
            losses.append(loss_accum)

            print("Epoch", epoch, "training loss:", loss_accum)
        # print("training time:", time() - start_time, "batch size:", batch_size)

    def predict(self, x: list[SingleFeature]):
        batch_size = 32
        preds = []

        dataset = DataLoader(x,
                             batch_size=batch_size,
                             shuffle=False,
                             collate_fn=collate_fn)
        for graph_batch, tree in dataset:
            if CUDA:
                graph_batch = graph_batch.to(device)

            neo4j_tree = self._net.build_trees(tree)
            y_pred = self._net(graph_batch, neo4j_tree).cpu().detach().numpy()
            preds.extend(y_pred.ravel().tolist())

        return preds

    @property
    def feature_generator(self):
        return self._feature_generator


class LeroModelCrossModels(LeroModel):
    def __init__(self, feature_generator: FeatureGenerator) -> None:
        self._net = None
        self._feature_generator = feature_generator
        self._pg_input_feature_dim = None
        self._neo4j_input_feature_dim = None
        self._model_parallel = None
        self.batch_size = None

    # X1/X2 will be a list of tuples and the first element is Data, the second element is SampleNeo4jEntity
    def fit(self, x1: list[SingleFeature], x2: list[SingleFeature], y1, y2):
        assert len(x1) == len(x2) and len(y1) == len(y2) and len(x1) == len(y1)
        if isinstance(y1, list):
            y1 = np.array(y1)
            y1 = y1.reshape(-1, 1)

        if isinstance(y2, list):
            y2 = np.array(y2)
            y2 = y2.reshape(-1, 1)

        # determine the initial number of channels for pg graph and for neo4j tree
        pg_input_feature_dim = x1[0].pg_feature.x.size(1)
        print("postgres plan graph input_feature_dim:", pg_input_feature_dim)

        neo4j_input_feature_dim = len(x1[0].neo4j_feature.get_feature())
        print("neo4j plan tree input_feature_dim:", neo4j_input_feature_dim)

        batch_size = 32

        self._net = LeroNetCrossModels(pg_input_feature_dim, neo4j_input_feature_dim, batch_size)
        self._pg_input_feature_dim = pg_input_feature_dim
        self._neo4j_input_feature_dim = neo4j_input_feature_dim
        self.batch_size = batch_size

        if CUDA:
            self._net = self._net.cuda(device)
            # self._net = torch.nn.DataParallel(self._net, device_ids=GPU_LIST)
            self._net.cuda(device)

        pairs = []
        for i in range(len(x1)):
            pairs.append((x1[i], x2[i], 1.0 if y1[i] >= y2[i] else 0.0))

        if CUDA:
            batch_size = batch_size * len(GPU_LIST)

        # collate_fn gets the batches for training
        dataset = DataLoader(pairs,
                             batch_size=batch_size,
                             shuffle=True,
                             collate_fn=collate_pairwise_fn,
                             drop_last=True)

        optimizer = None
        if CUDA:
            optimizer = torch.optim.Adam(self._net.parameters())
            # optimizer = nn.DataParallel(optimizer, device_ids=GPU_LIST)
        else:
            optimizer = torch.optim.Adam(self._net.parameters())
        bce_loss_fn = torch.nn.BCELoss()

        losses = []
        sigmoid = nn.Sigmoid()
        start_time = time()
        for epoch in range(30):
            loss_accum = 0
            for graph1_batch, graph2_batch, tree1_batch, tree2_batch, labels in dataset:

                if CUDA:
                    graph1_batch = graph1_batch.to(device)
                    graph2_batch = graph2_batch.to(device)
                    labels = labels.to(device)
                    neo4j_tree_x1 = self._net.build_trees(tree1_batch)
                    neo4j_tree_x2 = self._net.build_trees(tree2_batch)
                else:
                    neo4j_tree_x1 = self._net.build_trees(tree1_batch)
                    neo4j_tree_x2 = self._net.build_trees(tree2_batch)

                # pairwise
                y_pred_1 = self._net(graph1_batch, neo4j_tree_x1)
                y_pred_2 = self._net(graph2_batch, neo4j_tree_x2)
                diff = y_pred_1 - y_pred_2
                prob_y = sigmoid(diff)

                label_y = labels.reshape(-1, 1)
                #if CUDA:
                #    label_y = labels.cuda(device)

                loss = bce_loss_fn(prob_y, label_y)
                loss_accum += loss.item()

                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

            loss_accum /= len(dataset)
            losses.append(loss_accum)

            print("Epoch", epoch, "training loss:", loss_accum)
        # print(f"Training time: {time() - start_time} seconds, Batch size: {batch_size}")

    def evaluate(self, x1, x2, y1, y2):
        batch_size = 32
        pairs = []
        for i in range(len(x1)):
            pairs.append((x1[i], x2[i], 1.0 if y1[i] >= y2[i] else 0.0))

        # collate_fn gets the batches for training
        dataset = DataLoader(pairs,
                             batch_size=batch_size,
                             shuffle=False,
                             collate_fn=collate_pairwise_fn)
        total_correct = 0
        total_predictions = 0

        self._net.eval()
        with torch.no_grad():
            # Iterate over the test data loader
            for graph1_batch, graph2_batch, tree1_batch, tree2_batch, labels in dataset:
                # Process each batch through the corresponding part of your model
                if CUDA:
                    graph1_batch = graph1_batch.to(device)
                    graph2_batch = graph2_batch.to(device)
                    labels = labels.to(device)

                neo4j_tree_x1 = self._net.build_trees(tree1_batch)
                neo4j_tree_x2 = self._net.build_trees(tree2_batch)

                y_pred_1 = self._net(graph1_batch, neo4j_tree_x1)
                y_pred_2 = self._net(graph2_batch, neo4j_tree_x2)
                diff = y_pred_1 - y_pred_2
                predicates = torch.ge(diff, 0).int()  # This will give you a tensor of 0s and 1s

                # Calculate how many predictions are correct
                label_y = labels.reshape(-1, 1)
                correct = torch.eq(predicates, label_y).sum().item()  # Assuming labels are also 0s and 1s
                total_correct += correct
                total_predictions += predicates.size(0)
        # Calculate accuracy
        accuracy = total_correct / total_predictions
        print(f'Accuracy: {accuracy:.4f}')
