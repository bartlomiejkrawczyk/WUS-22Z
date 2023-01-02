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


RESOURCE_GROUP="$(jq -r '.resource_group' "$CONFIG_FILE")"

echo $RESOURCE_GROUP

# Login
az login --use-device-code

# Resource Group
az group create --name $RESOURCE_GROUP --location westeurope

# Network
NETWORK_ADDRESS_PREFIX="$(jq -r '.network.address_prefix' "$CONFIG_FILE")"

az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name VNet \
    --address-prefix $NETWORK_ADDRESS_PREFIX

# Network Security Group

readarray -t NETWORK_SECURITY_GROUPS < <(jq -c '.network_security_group[]' "$CONFIG_FILE")

for GROUP in "${NETWORK_SECURITY_GROUPS[@]}"; do
    echo $GROUP

    GROUP_NAME=$(jq -r '.name' <<< $GROUP)

    az network nsg create \
        --resource-group $RESOURCE_GROUP \
        --name $GROUP_NAME

    readarray -t RULES < <(jq -c '.rule[]' <<< $GROUP)

    for RULE in "${RULES[@]}"; do
        echo $RULE

        RULE_NAME=$(jq -r '.name' <<< $RULE)
        RULE_PRIORITY=$(jq -r '.priority' <<< $RULE)
        RULE_SOURCE_ADDRESS_PREFIX=$(jq -r '.source_address_prefixes' <<< $RULE)
        RULE_SOURCE_PORT_RANGES=$(jq -r '.source_port_ranges' <<< $RULE)
        RULE_DESTINATION_ADDRESS_PREFIX=$(jq -r '.destination_address_prefixes' <<< $RULE)
        RULE_DESTINATION_PORT_RANGES=$(jq -r '.destination_port_ranges' <<< $RULE)

        az network nsg rule create \
            --resource-group $RESOURCE_GROUP \
            --nsg-name $GROUP_NAME \
            --name $RULE_NAME \
            --access allow \
            --protocol Tcp \
            --priority $RULE_PRIORITY \
            --source-address-prefix "$RULE_SOURCE_ADDRESS_PREFIX" \
            --source-port-range "$RULE_SOURCE_PORT_RANGES" \
            --destination-address-prefix "$RULE_DESTINATION_ADDRESS_PREFIX" \
            --destination-port-range "$RULE_DESTINATION_PORT_RANGES"
    done
done

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
        --no-wait \
        --generate-ssh-keys

        # --data-disk-sizes-gb 10 \
        # --size Standard_DS2_v2 \
done

for PUBLIC_IP in "${PUBLIC_IPS[@]}"; do
    echo $PUBLIC_IP

    PUBLIC_IP_NAME=$(jq -r '.name' <<< $PUBLIC_IP)

    az network public-ip show \
      --resource-group "$RESOURCE_GROUP" \
      --name "$PUBLIC_IP_NAME" \
      --query "ipAddress" \
      --output tsv
done
