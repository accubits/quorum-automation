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
change quorum
#script for getting quorum
./get-quorum.sh
#script for setting up raft
./raft-setup.sh
#script for initialising the quorum
./raft-init.sh 
./constellation-start.sh
./raft-start.sh
#read -p $'\e[1;31mPlease enter this node\' IP Address: \e[0m' ip
#read -p $'\e[1;31mPlease enter this node\' enode hash without domain: \e[0m' enode
echo "raft.addPeer('enode://8dc1210d3d9cdb606b067a162db45e535f481663fda16bef717bad778b3631d5b017fb554a879d9fc8d006713195c0a7cd280a5ee2a72ada671a01d6207ba1cb@54.169.44.78:21000?discport=0&raftport=23000')"| geth attach qdata/geth.ipc 