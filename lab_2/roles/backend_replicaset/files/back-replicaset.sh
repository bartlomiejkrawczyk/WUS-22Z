#!/bin/bash

set -euxo pipefail

if [ "$#" -ne 7 ]; then
    echo "Usage: $0 SERVER_PORT DATABASE_MASTER_ADDRESS DATABASE_MASTER_PORT DATABASE_SLAVE_ADDRESS DATABASE_SLAVE_PORT DATABASE_USER DATABASE_PASSWORD" >&2
    exit 1
fi

SERVER_PORT="$1"
DATABASE_MASTER_ADDRESS="$2"
DATABASE_MASTER_PORT="$3"
DATABASE_SLAVE_ADDRESS="$4"
DATABASE_SLAVE_PORT="$5"
DATABASE_USER="$6"
DATABASE_PASSWORD="$7"

# Update configuration
sed -i "s/SERVER_PORT/$SERVER_PORT/g" ./application.properties
sed -i "s/DATABASE_MASTER_ADDRESS/$DATABASE_MASTER_ADDRESS/g" ./application.properties
sed -i "s/DATABASE_MASTER_PORT/$DATABASE_MASTER_PORT/g" ./application.properties
sed -i "s/DATABASE_SLAVE_ADDRESS/$DATABASE_SLAVE_ADDRESS/g" ./application.properties
sed -i "s/DATABASE_SLAVE_PORT/$DATABASE_SLAVE_PORT/g" ./application.properties
sed -i "s/DATABASE_USER/$DATABASE_USER/g" ./application.properties
sed -i "s/DATABASE_PASSWORD/$DATABASE_PASSWORD/g" ./application.properties
