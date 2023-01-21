#!/bin/bash

RESOURCE_GROUP="wusLabGroup"

set -euxo pipefail

# Login
az login

# Resource Group
az group create --name $RESOURCE_GROUP --location westeurope

az aks create --resource-group $RESOURCE_GROUP \
    --name wusCluster \
    --enable-managed-identity \
    --node-count 2 \
    --enable-addons monitoring \
    --enable-msi-auth-for-monitoring  \
    --generate-ssh-keys

sudo az aks install-cli

az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name wusCluster

kubectl get nodes
