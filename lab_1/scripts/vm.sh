#!/bin/bash

USERNAME="01158771@pw.edu.pl"
PASSWORD=""

# Instalation

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install azure-cli -y

# Login

az login --username USERNAME --password PASSWORD

# Security Group

az group create --name wusLabGroup --location westeurope

# Network

az network vnet create \
    --resource-group wusLabGroup \
    --name VNet \
    --address-prefix 10.0.0.0/16

# Network Security Group

az network nsg create \
	--resource-group wusLabGroup \
	--name frontendNSG

az network nsg rule create \
  --resource-group wusLabGroup \
  --nsg-name frontendNSG \
  --name http \
  --access allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 200 \
  --source-address-prefix "*" \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range 80

az network nsg create \
	--resource-group wusLabGroup \
	--name nginxNSG

az network nsg rule create \
  --resource-group wusLabGroup \
  --nsg-name backendNSG \
  --name HTTP \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 100 \
  --source-address-prefix 10.0.1.0/24 \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range 80

az network nsg create \
	--resource-group wusLabGroup \
	--name backendNSG

az network nsg rule create \
  --resource-group wusLabGroup \
  --nsg-name backendNSG \
  --name HTTP \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 100 \
  --source-address-prefix 10.0.1.0/24 \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range 80

az network nsg rule create \
  --resource-group wusLabGroup \
  --nsg-name backendNSG \
  --name HTTP \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 100 \
  --source-address-prefix 10.0.2.0/24 \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range 80

az network nsg create \
	--resource-group wusLabGroup \
	--name databaseNSG

az network nsg rule create \
  --resource-group wusLabGroup \
  --nsg-name backendNSG \
  --name MySQL \
  --access Allow \
  --protocol Tcp \
  --direction Inbound \
  --priority 200 \
  --source-address-prefix 10.0.3.0/24 \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range "3306"

#example to block all traffic inside vm (higher )
az network nsg rule create \
  --resource-group wusLabGroup \
  --nsg-name databaseNSG \
  --name denyAll \
  --access Deny \
  --protocol Tcp \
  --direction Inbound \
  --priority 300 \
  --source-address-prefix "*" \
  --source-port-range "*" \
  --destination-address-prefix "*" \
  --destination-port-range "*"

# Subnet

az network vnet subnet create \
    --resource-group wusLabGroup \
    --vnet-name VNet \
    --name frontendSubnet \
    --address-prefix 10.0.1.0/24 \
	--network-security-group frontendNSG

az network vnet subnet create \
    --resource-group wusLabGroup \
    --vnet-name VNet \
    --name nginxSubnet \
    --address-prefix 10.0.2.0/24 \
	--network-security-group nginxNSG

az network vnet subnet create \
    --resource-group wusLabGroup \
    --vnet-name VNet \
    --name backendSubnet \
    --address-prefix 10.0.3.0/24 \
	--network-security-group backendNSG

az network vnet subnet create \
    --resource-group wusLabGroup \
    --vnet-name VNet \
    --name databaseSubnet \
    --address-prefix 10.0.4.0/24 \
	--network-security-group databaseNSG

# Public IP

az network public-ip create \
    --resource-group wusLabGroup \
    --name publicIpAddress

# Virtual Machine

az vm create \
  --resource-group wusLabGroup \
  --name frontendVM \
  --vnet-name VNet \
  --subnet frontendSubnet \
  --nsg "" \
  --public-ip-address publicIpAddress \
  --image UbuntuLTS \
  --generate-ssh-keys

az vm create \
  --resource-group wusLabGroup \
  --name backendVM \
  --vnet-name VNet \
  --subnet backendSubnet \
  --public-ip-address "" \
  --nsg "" \
  --image UbuntuLTS \
  --generate-ssh-keys






