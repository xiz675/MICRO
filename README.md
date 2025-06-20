# Final Repo for Paper

This is the top-level repository for our paper, which includes multiple components.  
Each component has its own README explaining how to run the code and reproduce the corresponding results.

## Components

1. **`benchmark/`**  
   Contains all the workloads for each benchmark used in the paper.  
   Also includes code to generate your own benchmark workloads.

2. **`system/`**  
   Implements the MICRO system that executes cross-model query plans for each workload across all benchmarks.

3. **`xdbbaseline/`**  
   Provides code to run **XDB**, our baseline system, on the equivalent SQL versions of the benchmark workloads.

4. **`CMLero/`**  
   Includes code and pretrained models for reproducing the paper’s results.  
   Also provides scripts for training your own model on the training workloads and evaluating it on test workloads.

---

For details on each part, please refer to the corresponding `README.md` file inside each folder.  
