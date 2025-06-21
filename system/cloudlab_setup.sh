sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker --version
sudo usermod -aG docker $USER
# create a docker network for the three containers to communicate
#sudo docker network create lero-net
wget -qO - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
echo 'deb https://debian.neo4j.com stable latest' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
sudo apt-get update
# require yes
sudo apt install cypher-shell postgresql-client
sudo fdisk /dev/nvme1n1
sudo mkfs.ext4 -F /dev/nvme1n1p1
sudo mkdir -p /local
sudo mount /dev/nvme1n1p1 /local
# if you want to use SF10, set SF=10; if you want to use SF1, set SF=1
SF=10
mkdir -p /local/data
mkdir -p /local/code
mkdir -p /local/data/neo4jdata
mkdir -p /local/data/pgdata
# copy your code and data from permanent disk to /local/
cp -r /proj/awesome-PG0/cm_code /local/code/
cp -r /proj/awesome-PG0/cm_dataset/dataset/neo4jdata/sf$SF /local/data/neo4jdata/
cp -r /proj/awesome-PG0/cm_dataset/dataset/pgdata/sf$SF /local/data/pgdata/