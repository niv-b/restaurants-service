#!/bin/bash

# Log in to Azure interactively (for the first run only)
echo "Logging into Azure..."
az login
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Create a Service Principal with Contributor role and save the output
echo "Creating a Service Principal for Terraform..."
SP_OUTPUT=$(az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID")

# Extract values from the Service Principal creation output
CLIENT_ID=$(echo $SP_OUTPUT | jq -r '.appId')
CLIENT_SECRET=$(echo $SP_OUTPUT | jq -r '.password')
TENANT_ID=$(echo $SP_OUTPUT | jq -r '.tenant')

# Export environment variables for Terraform to use
echo "Setting environment variables for Terraform..."
export ARM_CLIENT_ID=$CLIENT_ID
export ARM_CLIENT_SECRET=$CLIENT_SECRET
export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
export ARM_TENANT_ID=$TENANT_ID

# Verify the environment variables are set (optional)
echo "Environment Variables set:"
echo "ARM_CLIENT_ID=$ARM_CLIENT_ID"
echo "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID"
echo "ARM_TENANT_ID=$ARM_TENANT_ID"

# Create a resource group for the state storage account
RESOURCE_GROUP_NAME="terraform-state-rg"
echo "Creating Resource Group for state storage..."
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Create a Storage Account for Terraform state
STORAGE_ACCOUNT_NAME="resturanttfstate"
echo "Creating Storage Account for Terraform state: $STORAGE_ACCOUNT_NAME"
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP_NAME \
  --sku Standard_LRS --encryption-services blob

# Create a Blob container for storing the Terraform state
CONTAINER_NAME="tfstate"
echo "Creating Blob Container for state storage..."
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

echo "Bootstrap script completed!"
