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
if [ $# -ne 1 ]
then :
echo "Please input a valid argument -m (Master Node) or -c (Child Node)"

elif [ $1 = '-c' ] || [ $1 = '-m' ]
then :
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
if [ $1 = '-c' ]
then :
curl -X GET  http://54.169.44.78:8020/api/v1/getBootNodes -o $PWD/../input_nodes.json
jq -c '.[]' $PWD/../input_nodes.json | while read i; do
	echo "raft.addPeer("$i")"| geth attach $PWD/qdata/geth.ipc
done
else :
jq -c '.[]' $PWD/raft/static-nodes.json | while read i; do
      	temp="${i%\"}"
	temp="${temp#\"}"
	curl -X POST http://54.169.44.78:8020/api/v1/addNode -H 'content-type: application/x-www-form-urlencoded' --data-urlencode 'enode='$temp -d 'typeNode=1'
done
fi
else :
echo "Please input a valid argument -m (Master Node) or -c (Child Node)"
fi
