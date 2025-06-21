# Data
## Local deployment 
For the CM-LDBC benchmark, we provide raw data for users to deploy locally or on CloudLab server like we did for the paper. The dataset is too large to be uploaded to Google drive. Please contact authors at xiz675@ucsd.edu for the dataset. 

## Remote connection 
For the Openalex-USPTO dataset, please contact us at xiz675@ucsd.edu for connection details (e.g., host, password) to our exsiting PostgreSQL and Neo4j servers that host the data. 


# Workload 
Workloads are provided in the `/workloads` folder. Each benchmark has a `llm.cypher` which are the Cypher queries directly extracted from LLM response. `correct_llm.cypher` which corrects the raw Cypher queries like correcting the edge directions and selects out correct Cypher queries after correction attempts. `cross_model_queries.txt` are the cross model queries (Cypher query + SQL query) rewritten from the Cypher queries. 

For the MICRO experiments, users can directly use `train.txt`, `test.txt` and `test_var.txt`, which are the training cross model queries, text queries with regular paths, and test queries with variable length paths. There are equivalent `.sql` files for the XDB baseline. 



# Create your own workloads
We provide the code of utilizing LLM models to generate cross-model workloads and choose syntatically correct workloads. 

Inside the `/realdata-workload_generation` or `/ldbc-workload_generation`, 
1. run `llm_workload_generation.py` to generate LLM queries
2. run `llm_workload_correction.py` to correct and select LLM queries
3. run  `crossmodel_query_rewrite.py` to generate cross-model queries from Cypher queries 
4. run  `generate_equivelent_sql.py` to generate equivalent SQL queries. 


