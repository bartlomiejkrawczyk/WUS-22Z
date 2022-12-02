#!/bin/bash

set -euxo pipefail

if [ $# -lt 1 ]; then
  echo 1>&2 "$0: not enough arguments"
  echo "Usage: $0 CONFIG_FILE"
  exit 2
fi

CONFIG_FILE="$1"

echo $CONFIG_FILE

# Instalation
sudo apt-get update
sudo apt-get upgrade -y

sudo apt install jq -y
sudo apt-get install azure-cli -y


RESOURCE_GROUP="$(jq -r '.resource_group' "$CONFIG_FILE")"

echo $RESOURCE_GROUP

# Login
az login

# Resource Group
az group create --name $RESOURCE_GROUP --location westeurope

# Network
NETWORK_ADDRESS_PREFIX="$(jq -r '.network.address_prefix' "$CONFIG_FILE")"

az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name VNet \
    --address-prefix $NETWORK_ADDRESS_PREFIX

# Network Security Group

# TODO: IMPLEMENT ME!
# Create security group
# add security rules

# Subnet

readarray -t SUBNETS < <(jq -c '.subnet[]' "$CONFIG_FILE")

for SUBNET in "${SUBNETS[@]}"; do
    echo $SUBNET

    SUBNET_NAME=$(jq -r '.name' <<< $SUBNET)
    SUBNET_ADDRESS_PREFIX=$(jq -r '.address_prefix' <<< $SUBNET)
    SUBNET_NETWORK_SECURITY_GROUP=$(jq -r '.network_security_group' <<< $SUBNET)
    echo $SUBNET_NAME

    az network vnet subnet create \
        --resource-group $RESOURCE_GROUP \
        --vnet-name VNet \
        --name $SUBNET_NAME \
        --address-prefix $SUBNET_ADDRESS_PREFIX \
        --network-security-group "$SUBNET_NETWORK_SECURITY_GROUP"
done

# Public IP

readarray -t PUBLIC_IPS < <(jq -c '.public_ip[]' "$CONFIG_FILE")

for PUBLIC_IP in "${PUBLIC_IPS[@]}"; do
    echo $PUBLIC_IP

    PUBLIC_IP_NAME=$(jq -r '.name' <<< $PUBLIC_IP)

    az network public-ip create \
        --resource-group $RESOURCE_GROUP \
        --name $PUBLIC_IP_NAME
done

# Virtual Machine

readarray -t VIRTUAL_MACHINES < <(jq -c '.virtual_machine[]' "$CONFIG_FILE")

for VM in "${VIRTUAL_MACHINES[@]}"; do
    echo $VM

    VM_NAME=$(jq -r '.name' <<< $VM)
    VM_SUBNET=$(jq -r '.subnet' <<< $VM)
    VM_PRIVATE_IP_ADDRESS=$(jq -r '.private_ip_address' <<< $VM)
    VM_PUBLIC_IP_ADDRESS=$(jq -r '.public_ip_address' <<< $VM)

    az vm create \
        --resource-group $RESOURCE_GROUP \
        --vnet-name VNet \
        --name $VM_NAME \
        --subnet $VM_SUBNET \
        --nsg "" \
        --private-ip-address "$VM_PRIVATE_IP_ADDRESS" \
        --public-ip-address "$VM_PUBLIC_IP_ADDRESS" \
        --image UbuntuLTS \
        --generate-ssh-keys
        
        # --data-disk-sizes-gb 10 \
        # --size Standard_DS2_v2 \
    
    readarray -t DEPLOY < <(jq -c '.deploy[]' <<< $VM)

    for SERVICE in "${DEPLOY[@]}"; do
        echo $SERVICE

        SERVICE_TYPE=$(jq -r '.type' <<< $SERVICE)
        SERVICE_PORT=$(jq -r '.port' <<< $SERVICE)

        case $SERVICE_TYPE in
            frontend)
                echo Setting up frontend

                az vm run-command invoke \
                    --resource-group $RESOURCE_GROUP \
                    --name $VM_NAME \
                    --command-id RunShellScript \
                    --scripts 'echo $1 $2' \
                    --parameters hello frontend
            ;;

            backend)
                echo Setting up backend

                az vm run-command invoke \
                    --resource-group $RESOURCE_GROUP \
                    --name $VM_NAME \
                    --command-id RunShellScript \
                    --scripts 'echo $1 $2' \
                    --parameters hello backend
            ;;

            database)
                echo Setting up database

                DATABASE_USER=$(jq -r '.user' <<< $SERVICE)
                DATABASE_PASSWORD=$(jq -r '.password' <<< $SERVICE)

                az vm run-command invoke \
                    --resource-group $RESOURCE_GROUP \
                    --name $VM_NAME \
                    --command-id RunShellScript \
                    --scripts "@./mySql/sql.sh" \
                    --parameters "$SERVICE_PORT" "$DATABASE_USER" "$DATABASE_PASSWORD"
            ;;

            *)
                echo 1>&2 "Unknown service type!"
                exit 1
            ;;

        esac
    done
done


# Delete
az group delete --name $RESOURCE_GROUP -y

az group delete --name NetworkWatcherRG -y

# Logout
az logout

