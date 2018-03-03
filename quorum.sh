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
git  clone https://gitlab.com/goutham_krishna/quorum.git
#change directory isn not allowed 
change quorum-raft-cluster
#script for getting quorum
./get-quorum.sh
#script for setting up raft
./raft-setup.sh
#script for initialising the quorum
./raft-init.sh 
./constellation-start.sh
./raft-start.sh