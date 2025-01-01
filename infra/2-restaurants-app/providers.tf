terraform {
  required_version = ">=1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.51, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }

  backend "azurerm" {
    resource_group_name      = "terraform-state-rg"
    storage_account_name     = "resttfstate1"
    container_name           = "tfstate"
    key                      = "aks/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
