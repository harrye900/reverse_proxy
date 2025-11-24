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

resource "azurerm_kubernetes_cluster" "ecommerce" {
  name                = "aks-ecommerce-cluster"
  location            = data.azurerm_resource_group.ecommerce.location
  resource_group_name = data.azurerm_resource_group.ecommerce.name
  dns_prefix          = "ecommerce-aks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
  }

  tags = {
    Environment = "Development"
    Project     = "Ecommerce"
  }
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

resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.ecommerce.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.ecommerce.id
  skip_service_principal_aad_check = true
}