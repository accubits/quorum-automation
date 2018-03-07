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
	#master node 1 
	if [ $1='-m' ]  &&  [ $2 = '1' ]
	then :
		jq -c '.[]' $PWD/raft/static-nodes.json | while read i; do
      	  	temp="${i%\"}"
	      	temp="${temp#\"}"
	      	curl -X POST http://$3:8020/api/v1/addNode -H 'content-type: application/x-www-form-urlencoded' --data-urlencode 'enode='$temp -d 'typeNode=1'
        done
    	read -p $'\e[1;31mSetup master node 2 2\' Press y to continue: \e[0m' choice
		echo $choice
        if [ choice ='y' ] || [ choice='Y' ]
        then :
		    sed -i d raft/static-nodes.json
			sleep 1
			chmod 777 raft/static-nodes.json
			sleep 2
			curl http://$3:8020/api/v1/getBootNodes >>$PWD/raft/static-nodes.json
			sleep 5
        	./raft-init.sh
        	sleep 5
        	./constellation-start.sh
            sleep 5
            ./raft-start.sh
            sleep 5
	   fi
	 elif [ $1='-m' ] && [ $2='2' ]
	 then :
	    echo "entered the if condition"
	 	jq -c '.[]' $PWD/raft/static-nodes.json | while read i; do
      	  	temp="${i%\"}"
	      	temp="${temp#\"}"
	      	curl -X POST http://$3:8020/api/v1/addNode -H 'content-type: application/x-www-form-urlencoded' --data-urlencode 'enode='$temp -d 'typeNode=1'
        done
		sleep 2
		sed -i d raft/static-nodes.json
		sleep 1
		chmod 777 raft/static-nodes.json
		sleep 3
		curl http://$3:8020/api/v1/getBootNodes >>$PWD/raft/static-nodes.json
		sleep 4
        ./raft-init.sh
        sleep 5
        ./constellation-start.sh
        sleep 5
        ./raft-start.sh
        sleep 5
          
    
 else :
    echo "your enode value is"
    cat $PWD/raft/static-nodes.json
	read -p $'\e[1;31mEnter your raftid\' IP Address: \e[0m' raftid
	./raft-init.sh
    sleep 5
    ./constellation-start.sh
    sleep 5
    ./raft-start.sh $raftid
    sleep 5


  fi
 #else :
 #echo "Please input a valid argument -m (Master Node) or -c (Child Node)"
fi