#!/bin/bash
docker stop tarantool-server #> /dev/null 2>&1 
rm -rf /my_tar_scripts

docker build -t custom_tar . 
docker run --rm -it -v /my_tar_scripts:/opt/tarantool --name tarantool-server -d custom_tar 
docker exec -it tarantool-server bash 
