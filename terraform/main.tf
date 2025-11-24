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

resource "azurerm_container_registry" "ecommerce" {
  name                = "acrecommerce${random_integer.suffix.result}"
  resource_group_name = data.azurerm_resource_group.ecommerce.name
  location            = data.azurerm_resource_group.ecommerce.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# Role assignment will be handled manually in the workflow