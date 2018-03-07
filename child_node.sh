#!/bin/bash
set -eu -o pipefail
#functions
function change(){
echo "traversing into the folder"
cd $1
}
function readdata(){
read -p $'\e[1;31mSetup master node 2\' IP Address: \e[0m' ip
read -p $'\e[1;31mPlease enter this node\' enode hash without domain: \e[0m' enode
}
#getting the nessecary files from git repo
#readdata
regex="\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
if [ $# -ne 3 ]
then :
	echo "Please input a valid argument -m (Master Node) masternode number (1 or 2) and public ip address of mongo server"
 elif [ -z $(grep -oE "\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b" <<< $3 ) ]
 then :
	echo "Please input a valid public ip address of mongo server"
 elif [ $1 = '-m' ] || [ $1 ='-c' ]
 then :
	apt-get install git
   	apt-get update
	apt-get install jq
	git  clone https://gitlab.com/goutham_krishna/quorum.git 
	change quorum
    ./get-quorum.sh
	./raft-setup.sh
    echo "your enode value is"
    cat $PWD/raft/static-nodes.json
	read -p $'\e[1;31mEnter your raftid\' IP Address: \e[0m' raftid
	./raft-init.sh
    sleep 5
    ./constellation-start.sh
    sleep 5
    ./raft-start.sh $raftid
    sleep 5

 else :
 echo "Please input a valid argument -m (Master Node) or -c (Child Node)"
fi
