#!/bin/bash

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 NGINX_PORT READ_SERVER_ADDRESS READ_SERVER_PORT WRITE_SERVER_ADDRESS WRITE_SERVER_PORT" >&2
    exit 1
fi

NGINX_PORT=$1
READ_SERVER_ADDRESS=$2
READ_SERVER_PORT=$3
WRITE_SERVER_ADDRESS=$4
WRITE_SERVER_PORT=$5

NGINX_CONFIG="https://raw.githubusercontent.com/bartlomiejkrawczyk/WUS-22Z/master/lab_1/scripts/nginx/nginx.conf"

# Instalation
sudo apt-get update
sudo apt-get upgrade -y

sudo apt install nginx -y
sudo apt install wget -y

# Download configuration
wget $NGINX_CONFIG

# Update configuration
sed -i "s/NGINX_PORT/$NGINX_PORT/g" ./nginx.conf
sed -i "s/READ_SERVER_ADDRESS/$READ_SERVER_ADDRESS/g" ./nginx.conf
sed -i "s/READ_SERVER_PORT/$READ_SERVER_PORT/g" ./nginx.conf
sed -i "s/WRITE_SERVER_ADDRESS/$WRITE_SERVER_ADDRESS/g" ./nginx.conf
sed -i "s/WRITE_SERVER_PORT/$WRITE_SERVER_PORT/g" ./nginx.conf

sudo cp ./nginx.conf /etc/nginx/conf.d/lb.conf

# Restart service
sudo systemctl restart nginx.service

echo DONE
