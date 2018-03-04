#!/bin/bash
set -eu -o pipefail
#functions
function change(){
echo "traversing into the folder"
cd $1
}
function readdata(){
read -p $'\e[1;31mPlease enter this node\' IP Address: \e[0m' ip
read -p $'\e[1;31mPlease enter this node\' enode hash without domain: \e[0m' enode
}
#getting the nessecary files from git repo
#readdata
apt-get install git
apt-get update
apt-get install jq
git  clone https://gitlab.com/goutham_krishna/quorum.git
#change directory isn not allowed 
change quorum
#script for getting quorum
./get-quorum.sh
#script for setting up raft
./raft-setup.sh
#script for initialising the quorum
./raft-init.sh
sleep 5
./constellation-start.sh
sleep 5
./raft-start.sh
sleep 5
jq -c '.[]' $PWD/../input_nodes.json | while read i; do
	echo "raft.addPeer("$i")"| geth attach $PWD/qdata/geth.ipc 
done
