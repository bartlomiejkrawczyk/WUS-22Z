#!/bin/bash

set -euxo pipefail

if [ $# -lt 5 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo "Usage: $0 DATABASE_PORT DATABASE_USER DATABASE_PASSWORD MASTER_DATABASE_ADDRESS MASTER_DATABASE_PORT"
  exit 1
fi

DATABASE_PORT=$1
DATABASE_USER=$2
DATABASE_PASSWORD=$3
MASTER_DATABASE_ADDRESS=$4
MASTER_DATABASE_PORT=$5

MY_SQL_CONFIG="/etc/mysql/mysql.conf.d/mysqld.cnf"
USER_DATABASE="https://raw.githubusercontent.com/bartlomiejkrawczyk/WUS-22Z/master/lab_1/scripts/mySql/user.sql"
INIT_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql"
POPULATE_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql"

cd ~/

# Instalation
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove -y

sudo apt-get install mysql-server -y
sudo apt-get install wget -y

# Download config files
wget $USER_DATABASE
wget $INIT_DATABASE
wget $POPULATE_DATABASE

# Update configuration
echo "port = $DATABASE_PORT" >> $MY_SQL_CONFIG
echo "server-id = 2" >> $MY_SQL_CONFIG
echo "read_only = 1" >> $MY_SQL_CONFIG

sed -i "s/127.0.0.1/0.0.0.0/g" $MY_SQL_CONFIG
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

STATEMENT="CHANGE MASTER TO MASTER_HOST='${MASTER_DATABASE_ADDRESS}', MASTER_PORT=${MASTER_DATABASE_PORT}, MASTER_USER='${DATABASE_USER}', MASTER_PASSWORD='${DATABASE_PASSWORD}';"
echo $STATEMENT

sudo mysql -v -e "${STATEMENT}"
sudo mysql -v -e "START SLAVE;"
sudo mysql -v -e "SHOW SLAVE STATUS\G;"

echo DONE
