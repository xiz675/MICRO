# import argparse
#
# from load_workloads import prepare_input
#
#
# def train_model():
#
#
#
# def evaluate_model():
#
#
#
# if __name__ == '__main__':
#     # load the files
#     parser = argparse.ArgumentParser("Train and evaluate model")
#     parser.add_argument('--model-name', dest='model_name', type=str, required=True)
#     parser.add_argument('--training-data', dest='training_data', type=str, required=True)
#
#     args = parser.parse_args()
#     # Each comparison is regarded as a data point
#     # todo: read the file and split by train and test
#     pairwise_training(args.training_data, args.model_name)
#
#
#     # read all the workloads, partition by train data and test data
#     workloads, all_relations_stats = prepare_input(path_prefix)
#
#
#
#     # use training data for model training and use test data for evaluation
#
#
#
