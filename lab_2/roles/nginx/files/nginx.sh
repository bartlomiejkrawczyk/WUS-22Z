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

# Update configuration
sed -i "s/NGINX_PORT/$NGINX_PORT/g" /etc/nginx/conf.d/lb.conf
sed -i "s/READ_SERVER_ADDRESS/$READ_SERVER_ADDRESS/g" /etc/nginx/conf.d/lb.conf
sed -i "s/READ_SERVER_PORT/$READ_SERVER_PORT/g" /etc/nginx/conf.d/lb.conf
sed -i "s/WRITE_SERVER_ADDRESS/$WRITE_SERVER_ADDRESS/g" /etc/nginx/conf.d/lb.conf
sed -i "s/WRITE_SERVER_PORT/$WRITE_SERVER_PORT/g" /etc/nginx/conf.d/lb.conf
