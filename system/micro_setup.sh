# if using sf10, change sf1 to sf10 
# create neo4j container
cd /local/data/neo4jdata/sf1/scripts
sudo su
# bash load-in-one-step.sh
# if the data is already loaded, run:
bash start.sh
docker run --name lero-postgres-sf1 -e POSTGRES_PASSWORD=xw -p 5432:5432 -v /local/data/pgdata/sf1/db2/data:/var/lib/postgresql/data --network=lero-net -d postgres:16