# AKS Infrastructure for Ecommerce Application
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "ecommerce" {
  name = "rg-ecommerce-aks"
}

data "azurerm_kubernetes_cluster" "ecommerce" {
  name                = "aks-ecommerce-cluster"
  resource_group_name = data.azurerm_resource_group.ecommerce.name
}

data "azurerm_container_registry" "ecommerce" {
  name                = "acrecommerce1809"
  resource_group_name = data.azurerm_resource_group.ecommerce.name
}

# Role assignment will be handled manually in the workflow