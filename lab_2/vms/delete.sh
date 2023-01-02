#!/bin/bash

set -euxo pipefail

if [ $# -lt 1 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo "Usage: $0 CONFIG_FILE"
  exit 2
fi

CONFIG_FILE="$1"

RESOURCE_GROUP="$(cat $CONFIG_FILE | jq -r '.resource_group')"

# Instalation
sudo apt-get update
sudo apt-get upgrade -y

sudo apt install jq -y
sudo apt-get install azure-cli -y

# Login
az login --use-device-code

# Delete
az group delete --name $RESOURCE_GROUP -y

az group delete --name NetworkWatcherRG -y

# Logout
az logout
