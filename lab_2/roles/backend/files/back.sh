#!/bin/bash

set -euxo pipefail

if [ "$#" -ne 5 ]; then
    echo "Usage: $0 SERVER_PORT DATABASE_ADDRESS DATABASE_PORT DATABASE_USER DATABASE_PASSWORD" >&2
    exit 1
fi

SERVER_PORT="$1"
DATABASE_ADDRESS="$2"
DATABASE_PORT="$3"
DATABASE_USER="$4"
DATABASE_PASSWORD="$5"

# Update configuration
sed -i "s/SERVER_PORT/$SERVER_PORT/g" application.properties
sed -i "s/DATABASE_ADDRESS/$DATABASE_ADDRESS/g" application.properties
sed -i "s/DATABASE_PORT/$DATABASE_PORT/g" application.properties
sed -i "s/DATABASE_USER/$DATABASE_USER/g" application.properties
sed -i "s/DATABASE_PASSWORD/$DATABASE_PASSWORD/g" application.properties
