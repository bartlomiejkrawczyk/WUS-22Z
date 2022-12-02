#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Potrzebne dane do użycia skryptu: $0 SERVER_PORT DATABASE_ADDRESS DATABASE_PORT DATABASE_USER DATABASE_PASSWORD" >&2
    exit 1
fi

SERVER_PORT="$1"
DATABASE_ADDRESS="$2"
DATABASE_PORT="$3"
DATABASE_USER="$4"
DATABASE_PASSWORD="$5"

SPRING_CONFIG="./wus-22z/lab_1/scripts/rest/application.properties"
SERVER_CONFIG="./spring-petclinic-rest/src/main/resources/application.properties"

cd ~/

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install openjdk-8-jdk
java -version

git clone https://github.com/bartlomiejkrawczyk/WUS-22Z.git

git clone https://github.com/spring-petclinic/spring-petclinic-rest.git


cp $SPRING_CONFIG $SERVER_CONFIG

sed -i "s/SERVER_PORT/$SERVER_PORT/g" $SERVER_CONFIG
sed -i "s/DATABASE_ADDRESS/$DATABASE_ADDRESS/g" $SERVER_CONFIG
sed -i "s/DATABASE_PORT/$DATABASE_PORT/g" $SERVER_CONFIG
sed -i "s/DATABASE_USER/$DATABASE_USER/g" $SERVER_CONFIG
sed -i "s/DATABASE_PASSWORD/$DATABASE_PASSWORD/g" $SERVER_CONFIG

cd ./spring-petclinic-rest/

./mvnw spring-boot:run