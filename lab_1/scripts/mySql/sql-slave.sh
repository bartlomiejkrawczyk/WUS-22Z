#!/bin/bash

set -euxo pipefail

if [ $# -lt 3 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo "Usage: $0 DATABASE_PORT DATABASE_USER DATABASE_PASSWORD MASTER_DATABASE_ADDRESS MASTER_DATABASE_PORT"
  exit 1
fi

DATABASE_PORT=$1
DATABASE_USER=$2
DATABASE_PASSWORD=$3
MASTER_DATABASE_ADDRESS=$4
MASTER_DATABASE_PORT=$5

MY_SQL_CONFIG="https://raw.githubusercontent.com/bartlomiejkrawczyk/WUS-22Z/master/lab_1/scripts/mySql/.my2.cnf"
USER_DATABASE="https://raw.githubusercontent.com/bartlomiejkrawczyk/WUS-22Z/master/lab_1/scripts/mySql/user.sql"
INIT_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql"
POPULATE_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql"

cd ~/

# Instalation
sudo apt-get update
sudo apt-get upgrade -y

sudo apt install mysql-server -y
sudo apt install wget -y

# Download config files
wget $MY_SQL_CONFIG -o ./.my.cnf
wget $USER_DATABASE
wget $INIT_DATABASE
wget $POPULATE_DATABASE

# Update configuration
sed -i "s/DATABASE_PORT/$DATABASE_PORT/g" ./.my.cnf
sed -i "s/DATABASE_USER/$DATABASE_USER/g" ./user.sql
sed -i "s/DATABASE_PASSWORD/$DATABASE_PASSWORD/g" ./user.sql
sed -i "1s/^/USE petclinic;\n/" ./populateDB.sql

# Run sql
cat ./user.sql | sudo mysql -f
cat ./initDB.sql | sudo mysql -f
cat ./populateDB.sql | sudo mysql -f

# Restart service
sudo service mysql restart

# Change master

sudo mysql -e "CHANGE MASTER TO MASTER_HOST='$MASTER_DATABASE_ADDRESS', MASTER_PORT=$MASTER_DATABASE_PORT, MASTER_USER='$DATABASE_USER', MASTER_PASSWORD='$DATABASE_PASSWORD';start slave;"
