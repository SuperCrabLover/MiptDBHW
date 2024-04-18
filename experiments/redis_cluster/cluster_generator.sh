#!/bin/bash

# Create redis_cluster directory
mkdir test
cd test
mkdir redis_cluster
PORT1=7001
PORT2=7002
PORT3=7003
# Array of directory names
DIR_NAMES=("$PORT1" "$PORT2" "$PORT3")

# Loop through directory names
for DIR_NAME in "${DIR_NAMES[@]}"
do
    # Create directory
    mkdir "redis_cluster/$DIR_NAME"

    # Create redis.conf file
    cat <<EOF > "redis_cluster/$DIR_NAME/redis.conf"
port $DIR_NAME
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOF

    # Start Redis server
    redis-server redis_cluster/$DIR_NAME/./redis.conf & disown redis-server
done
echo "hi!"
# Execute redis-cli to create cluster
redis-cli --cluster create localhost:$PORT1 localhost:$PORT2 localhost:$PORT3  --cluster-replicas 0 

