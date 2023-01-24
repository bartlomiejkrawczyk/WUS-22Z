#!/bin/bash

RESOURCE_GROUP="wusLabGroup"

set -euxo pipefail

# Login
az login

# Resource Group
az group create --name $RESOURCE_GROUP --location westeurope

# Cluster
az aks create --resource-group $RESOURCE_GROUP \
    --name wusCluster \
    --enable-managed-identity \
    --node-count 2 \
    --generate-ssh-keys

az aks enable-addons --addons monitoring \
    --resource-group $RESOURCE_GROUP \
    --name wusCluster

# Update kubectl configuration
az aks get-credentials \
    --resource-group $RESOURCE_GROUP \
    --name wusCluster

# Check whether nodes are up
kubectl get nodes
