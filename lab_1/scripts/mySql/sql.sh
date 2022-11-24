#!/bin/bash

DATABASE_PORT=3306

DATABASE_USER=admin
DATABASE_PASSWORD=admin

# DATABASE_PORT=$1
# DATABASE_USER=$2
# DATABASE_PASSWORD=$3

DATABASE_CONFIG="./wus-22z/lab_1/scripts/mySql/.my.cnf"

cd ~/

sudo apt-get update
sudo apt-get upgrade -y

sudo apt install mariadb-server-10.3 -y

git clone https://github.com/bartlomiejkrawczyk/WUS-22Z.git

cp $DATABASE_CONFIG ~/.my.cnf

sudo service mysql restart
