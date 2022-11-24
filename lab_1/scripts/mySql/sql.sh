#!/bin/bash

DATABASE_PORT=3306

DATABASE_USER=admin
DATABASE_PASSWORD=admin

# DATABASE_PORT=$1
# DATABASE_USER=$2
# DATABASE_PASSWORD=$3

cd ~/

sudo apt-get update
sudo apt-get upgrade -y

sudo apt install mysql-server=5.7.8 -y


