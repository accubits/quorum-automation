#!/bin/bash
set -eu -o pipefail
#functions
function change(){
echo "traversing into the folder"
cd $1
}
#getting the nessecary files from git repo
apt-get install git
apt-get update
git  clone https://github.com/Szkered/quorum-raft-cluster.git
#change directory isn not allowed 
change quorum-raft-cluster
#script for getting quorum
./get-quorum.sh
#script for setting up raft
./raft-setup.sh
