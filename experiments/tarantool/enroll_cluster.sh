#!/bin/bash
DATA_PATH=/opt/tarantool/
DIR_PATH=~/instances.enabled/bill
cd ~
tt init
mkdir -p $DIR_PATH
echo "Creating configs"
mv $DATA_PATH/router.lua $DIR_PATH
mv $DATA_PATH/storage.lua $DIR_PATH
mv $DATA_PATH/config.yaml $DIR_PATH
mv $DATA_PATH/instances.yaml $DIR_PATH
mv $DATA_PATH/bill-scm-1.rockspec $DIR_PATH

sleep 1
echo "Starting cluster"

tt build bill
sleep 1
tt start bill 
sleep 1
tt connect bill:router-a-001
