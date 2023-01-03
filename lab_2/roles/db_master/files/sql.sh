#!/bin/bash

set -euxo pipefail

if [ $# -lt 3 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo "Usage: $0 DATABASE_PORT DATABASE_USER DATABASE_PASSWORD"
  exit 1
fi

DATABASE_PORT=$1
DATABASE_USER=$2
DATABASE_PASSWORD=$3

MY_SQL_CONFIG="/etc/mysql/mysql.conf.d/mysqld.cnf"
USER_DATABASE="https://raw.githubusercontent.com/bartlomiejkrawczyk/WUS-22Z/master/lab_1/scripts/mySql/user.sql"
INIT_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/initDB.sql"
POPULATE_DATABASE="https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/master/src/main/resources/db/mysql/populateDB.sql"

# Download config files
wget $USER_DATABASE
wget $INIT_DATABASE
wget $POPULATE_DATABASE

# Update configuration
echo "port = $DATABASE_PORT" >> $MY_SQL_CONFIG
echo "server-id = 1" >> $MY_SQL_CONFIG
echo "log_bin = /var/log/mysql/mysql-bi.log" >> $MY_SQL_CONFIG

sed -i "s/127.0.0.1/0.0.0.0/g" $MY_SQL_CONFIG
sed -i "s/DATABASE_USER/$DATABASE_USER/g" ./user.sql
sed -i "s/DATABASE_PASSWORD/$DATABASE_PASSWORD/g" ./user.sql
sed -i "1s/^/USE petclinic;\n/" ./populateDB.sql

cat $MY_SQL_CONFIG


# Run sql
cat ./user.sql | sudo mysql -f
cat ./initDB.sql | sudo mysql -f
cat ./populateDB.sql | sudo mysql -f

# Restart service
sudo service mysql restart

sudo mysql -v -e "UNLOCK TABLES;"

echo DONE
