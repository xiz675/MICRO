# Cloudlab Setup

If you are using a CloudLab node:

1. **Download the data and code** to a permanent disk space under your project (e.g., `/proj/`), so you won't lose your data after reboot.

2. **Run the setup script** to install Docker and prepare the datasets and code:

    ```bash
    bash cloudlab_setup.sh
    ```

3. **Run the script to create Docker containers** for PostgreSQL and Neo4j, load the datasets, and place them under the same Docker network:

    ```bash
    bash micro_setup.sh
    ```

4. **Create a Python Docker container for MICRO**:

    ```bash
    docker run -it --name lero-python --network lero-net \
      -v /local/code/:/app \
      -v /local/data/:/data \
      -v /proj/awesome-PG0/cm_result/:/result \
      python:3.12 /bin/bash

    pip install --upgrade pip
    cd /app/cm_code/system
    pip install -r ./requirements.txt
    ```

5. **Inside the Python Docker container, run the workload**:

    ```bash
    # For sf1-t1
    python run_workload.py \
      --nj-uri lero-neo4j-sf1 \
      --pg-host lero-postgres \
      --pg-pw <yourpassword> \
      --query-path <cross-model-query-path> \
      --result-path <result-path>

    # For sf1-t2
    python run_workload.py \
      --nj-uri lero-neo4j-sf1 \
      --pg-host lero-postgres \
      --pg-db t2 \
      --pg-pw <yourpassword> \
      --query-path <cross-model-query-path> \
      --result-path <result-path>
    ```

> The query files are located in the `/benchmark/workloads/` folder.

# Result
The computed results for all the benchmark train and test queries can be found in `/system/results` folder.  