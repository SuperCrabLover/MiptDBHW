#!/bin/bash
docker stop tarantool-server #> /dev/null 2>&1 
rm -rf /my_tar_scripts

docker build -t custom_tar . 
docker run --rm -it -v /my_tar_scripts:/opt/tarantool --name tarantool-server -d custom_tar 
cp $(pwd)/custom_router.lua /my_tar_scripts/router.lua
cp $(pwd)/custom_storage.lua /my_tar_scripts/storage.lua
cp $(pwd)/enroll_cluster.sh /my_tar_scripts/enroll_cluster.sh
chmod +x /my_tar_scripts/enroll_cluster.sh
docker exec -it tarantool-server bash 

