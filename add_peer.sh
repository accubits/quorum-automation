#!/bin/bash
set -u
set -e
echo "raft.addPeer("$1")"| geth attach /home/ubuntu/script-quorum/quorum/qdata/geth.ipc
