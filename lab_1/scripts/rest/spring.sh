#!/bin/bash
set -euxo pipefail

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 SERVER_PORT DATABASE_ADDRESS DATABASE_PORT DATABASE_USER DATABASE_PASSWORD" >&2
    exit 1
fi

DIRECTORY="$RANDOM"

echo $DIRECTORY

SERVER_PORT="$1"
DATABASE_ADDRESS="$2"
DATABASE_PORT="$3"
DATABASE_USER="$4"
DATABASE_PASSWORD="$5"

SPRING_CONFIG="https://raw.githubusercontent.com/bartlomiejkrawczyk/WUS-22Z/master/lab_1/scripts/rest/application.properties"
SERVER_CONFIG="./spring-petclinic-rest/src/main/resources/application.properties"

cd ~/

mkdir $DIRECTORY

cd $DIRECTORY/

# Instalation
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install openjdk-8-jdk -y
java -version

# Download project
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git

wget $SPRING_CONFIG -o $SERVER_CONFIG

# Update configuration
sed -i "s/SERVER_PORT/$SERVER_PORT/g" $SERVER_CONFIG
sed -i "s/DATABASE_ADDRESS/$DATABASE_ADDRESS/g" $SERVER_CONFIG
sed -i "s/DATABASE_PORT/$DATABASE_PORT/g" $SERVER_CONFIG
sed -i "s/DATABASE_USER/$DATABASE_USER/g" $SERVER_CONFIG
sed -i "s/DATABASE_PASSWORD/$DATABASE_PASSWORD/g" $SERVER_CONFIG

# Test and run project
cd ./spring-petclinic-rest/
./mvnw spring-boot:run &
