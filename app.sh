#!/bin/bash
set -eu -o pipefail
#functions
function change()
{
 echo "traversing into the folder" cd $1
}
apt-get install git
apt-get update

git  clone https://gitlab.com/accubitstech/landReg.git

cd  landReg

npm install

#install mongodb

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

apt-get update

apt-get install -y mongodb-org

service mongod start

npm install -g pm2

npm install -g truffle

pm2 start index.js --name landReg

cd ..
npm install connect serve-static
git clone https://gitlab.com/accubitstech/landRegWeb.git
pm2 start server.js --name landRegWeb

echo "Completed the dependencies installation."
