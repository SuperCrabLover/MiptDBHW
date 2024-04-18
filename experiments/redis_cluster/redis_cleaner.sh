#!/bin/bash

# Get list of PIDs for processes containing "redis" excluding PID 1
REDIS_PIDS=$(ps aux | grep '[r]edis' | awk '$2 != 1 {print $2}')

# Check if there are any redis processes running
if [ -n "$REDIS_PIDS" ]; then
    echo "Found Redis processes, killing them..."
    # Loop through each PID and kill the process
    for PID in $REDIS_PIDS; do
        echo "Killing process with PID: $PID"
        kill -9 "$PID"
    done
else
    echo "No Redis processes found."
fi

