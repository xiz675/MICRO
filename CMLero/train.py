import argparse
import time

from crossmodel import LeroModelCrossModels, LeroModel
from features import FeatureGenerator, get_pairwise_plan, get_pointwise_plan

from load_workloads import prepare_input


def feature_generator_training(workloads, relation_stats):
    # generating features and labels using feature generator
    feature_generator = FeatureGenerator()
    feature_generator.fit(workloads, relation_size=relation_stats)
    # transform all input data: for each plan, modify the raw neo4j plan, extract feature from the modified plan,
    # also extract features for the GNN model
    # extract features per workload: a list of lists, each list is all plans for a single workload
    # each inner list contains two part: tree feature (neo4j part) and gnn feature (Data)
    # if the query run_time out of time, then remove the plan
    features, labels = feature_generator.transform(workloads, relation_stats)
    return features, labels, feature_generator


def pairwise_training(train_features, train_labels, feature_generator, model_name: str):
    """
    Call the prepare_input function to prepare the pairwise features and labels for model training
    Call the model training to train the lero model
    """
    start_time = time.time()

    x1, x2, y1, y2 = get_pairwise_plan(train_features, train_labels)
    # print(f"Training data set size {len(x1)}")
    lero_model = LeroModelCrossModels(feature_generator)
    # todo: when training, print the accuracy on test dataset to see how much it overfit
    lero_model.fit(x1, x2, y1, y2)

    print(f"""model training for {model_name} takes {time.time() - start_time} s""")
    print(f"""model training for {model_name} has training size: {len(y1)}""")

    print("saving model....")
    lero_model.save(model_name)
    lero_model.evaluate(x1, x2, y1, y2)
    # lero_model.predict(x1)
    # lero_model.predict(x2)


def pointwise_training(train_features, train_labels, feature_generator, model_name: str):
    """
    the pointwise baseline
    """
    start_time = time.time()
    x, y = get_pointwise_plan(train_features, train_labels)
    lero_model = LeroModel(feature_generator)
    lero_model.fit(x, y)
    print(f"""model training for {model_name} takes {time.time() - start_time} s""")
    print(f"""model training for {model_name} has training size: {len(y)}""")

    # lero_model.evaluate(features, labels)
    lero_model.predict(x)

    print("saving model....")
    lero_model.save(model_name)


if __name__ == '__main__':
    # load the files
    parser = argparse.ArgumentParser("Model training helper")
    parser.add_argument('--model-name', dest='model_name', type=str, required=True)
    parser.add_argument('--training-data', dest='training_data', type=str, required=True)
    parser.add_argument('--evaluate-data', dest='evaluate_data', type=str, required=False)

    args = parser.parse_args()
    model_base_name = args.model_name
    training_data = args.training_data
    evaluate_data = args.evaluate_data
    # pairwise training
    # use different numbers of workloads as training workloads and evaluate their performance
    start_time = time.time()
    training_workloads, rel_stats = prepare_input(training_data)
    features, labels, feature_gen = feature_generator_training(training_workloads, rel_stats)

    # evaluate_workloads, _ = prepare_input(evaluate_data)
    # eva_features, eva_labels, eva_feature_gen = feature_generator_training(evaluate_workloads, rel_stats)

#    pairwise_training(features, labels, feature_gen, f"""{model_base_name}-pair""")
    pointwise_training(features, labels, feature_gen, model_name=f"""{model_base_name}-point""")
#    for num_of_queries in [100, 200, 300, 400, 500]:
#        training_workloads, rel_stats = prepare_input(training_data, num_of_queries)
#        features, labels, feature_gen = feature_generator_training(training_workloads, rel_stats)
#        pairwise_training(features, labels, feature_gen, model_name=f"""{model_base_name}-pair-{num_of_queries}""")
#        pointwise_training(features, labels, feature_gen, model_name=f"""{model_base_name}-point-{num_of_queries}""")
