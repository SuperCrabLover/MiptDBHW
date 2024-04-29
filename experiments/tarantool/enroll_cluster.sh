#!/bin/bash

echo "Creating configs"
tt create vshard_cluster --name bill -f --non-interactive -dst /opt/tt/apps/
sleep 1

echo "Customing configs"
rm $(pwd)/st/bill/router.lua
rm $(pwd)/st/bill/storage.lua

cp $(pwd)/router.lua $(pwd)/st/bill
cp $(pwd)/storage.lua $(pwd)/st/bill

sleep 1
echo "Starting cluster"

tt build bill
sleep 1
tt start bill 
sleep 1
tt connect bill:router-001-a
