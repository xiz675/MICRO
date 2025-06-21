# Docker Setups

## Load Graph Data into PostgreSQL

We created equivalent tables for the graph data and loaded them into a PostgreSQL container:

```bash
docker run --name lero-postgres2 \
  -e POSTGRES_PASSWORD=xw \
  -p 5433:5432 \
  -v /local/data/pgdata/{sf1,sf10}/db1/data:/var/lib/postgresql/data \
  --network=lero-net \
  -d postgres:16
```

## Load Table Data into PostgreSQL

```bash
docker run --name lero-postgres \
  -e POSTGRES_PASSWORD=xw \
  -p 5432:5432 \
  -v /local/data/pgdata/{sf1,sf10}/db2/data:/var/lib/postgresql/data \
  --network=lero-net \
  -d postgres:16
```

## Create `postgres_fdw` Extension and Set Up Foreign Servers

In the PostgreSQL shell:

```sql
-- Create the FDW extension
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Connect to pg1-sf10 (db1)
CREATE SERVER pg1_server FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'lero-postgres-sf10', dbname 'postgres', port '5432');

CREATE USER MAPPING FOR current_user SERVER pg1_server
  OPTIONS (user 'postgres', password 'xw');

IMPORT FOREIGN SCHEMA public
  FROM SERVER pg1_server
  INTO public;

-- Optional: remove the server if re-defining later
DROP SERVER pg1_server CASCADE;

-- Connect to pg1-sf1 (db2, t2)
CREATE SERVER pg1_server2 FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'lero-postgres-sf1', dbname 't2', port '5432');

CREATE USER MAPPING FOR current_user SERVER pg1_server2
  OPTIONS (user 'postgres', password 'xw');

IMPORT FOREIGN SCHEMA public
  FROM SERVER pg1_server2
  INTO public;
```

# Run Code

```bash
python run_query.py \
  --pg-host lero-postgres2 \
  --pg-pw xw \
  --query-path /app/cm_code/cross-model-query/sql-query/test.sql
```