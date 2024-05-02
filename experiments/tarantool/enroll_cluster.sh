#!/bin/bash
DATA_PATH=/opt/tarantool/
DIR_PATH=~/instances.enabled/bill
cd ~
tt init
mkdir -p $DIR_PATH
echo "Creating configs"
cp $DATA_PATH/router.lua $DIR_PATH
cp $DATA_PATH/storage.lua $DIR_PATH
cp $DATA_PATH/config.yaml $DIR_PATH
cp $DATA_PATH/instances.yaml $DIR_PATH
cp $DATA_PATH/bill-scm-1.rockspec $DIR_PATH

echo "Starting cluster"
tt rocks install expirationd
tt build bill
sleep 1
tt start bill 
sleep 1
tt connect bill:router-a-001
