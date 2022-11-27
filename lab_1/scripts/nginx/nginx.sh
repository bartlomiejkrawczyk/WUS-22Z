#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y

sudo apt install nginx -y

NGINX_CONFIG="./wus-22z/lab_1/scripts/nginx/nginx.conf"

git clone https://github.com/bartlomiejkrawczyk/WUS-22Z.git

sudo cp $NGINX_CONFIG /etc/nginx/nginx.conf

sudo systemctl start nginx




