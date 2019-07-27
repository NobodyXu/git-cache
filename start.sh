#!/usr/bin/env bash

start_server() {
    while true; do
        git-cache-http-server
	echo "git-cache-http-server exited with $?"
    done
}

start_server &

source /root/git-gc.sh
