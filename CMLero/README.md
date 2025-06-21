# Paper Result Reproduction

We saved the trained models in the `trained_models` folder.  
To reproduce the results in the paper, simply run `evaluate.py` on the test set of each benchmark.

For example, to evaluate the **OpenAlex-USPTO benchmark**, run:

```bash
python evaluate.py \
  --model-path ./trained_models/realdata \
  --test-data ./datafiles/real-data \
  --result-path ./evaluation_results/realdata
```

---

# Train Your Own Model

You can train your own model using the training dataset stored in:

```
./datafiles/<benchmark-name>/train
```

These training data are collected by running the **MICRO** system, which explores and executes all possible plans on training queries to record execution times.

To train your model, run:

```bash
python train.py \
  --model-name real-data \
  --training-data ./datafiles/real-data/train
```