#!/bin/bash

set -x

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 SERVER_IP SERVER_PORT" >&2
    exit 1
fi

SERVER_IP="$1"
SERVER_PORT="$2"

# Update configuration
sed -i "s/localhost/$SERVER_IP/g" src/environments/environment.ts src/environments/environment.prod.ts
sed -i "s/9966/$SERVER_PORT/g" src/environments/environment.ts src/environments/environment.prod.ts
