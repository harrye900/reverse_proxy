# Configure Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "b1d9dfac-423b-47ef-ba8b-e5d4c2050500"
  features {}
}

# Get existing resource group
data "azurerm_resource_group" "main" {
  name = "rg-ecommerce-aks"
}

# Create public IP for Application Gateway
resource "azurerm_public_ip" "app_gateway" {
  name                = "pip-appgw-ecommerce"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = {
    Environment = "production"
    Project     = "ecommerce"
  }
}

# Create virtual network for Application Gateway
resource "azurerm_virtual_network" "app_gateway" {
  name                = "vnet-appgw-ecommerce"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  address_space       = ["10.1.0.0/16"]
  
  tags = {
    Environment = "production"
    Project     = "ecommerce"
  }
}

# Create subnet for Application Gateway
resource "azurerm_subnet" "app_gateway" {
  name                 = "snet-appgw"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.app_gateway.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Get AKS cluster details
data "azurerm_kubernetes_cluster" "main" {
  name                = "aks-ecommerce-cluster"
  resource_group_name = data.azurerm_resource_group.main.name
}

# Get AKS VNet
data "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet-40259644"
  resource_group_name = "MC_rg-ecommerce-aks_aks-ecommerce-cluster_canadacentral"
}

# VNet Peering: App Gateway VNet to AKS VNet
resource "azurerm_virtual_network_peering" "appgw_to_aks" {
  name                      = "appgw-to-aks"
  resource_group_name       = data.azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.app_gateway.name
  remote_virtual_network_id = data.azurerm_virtual_network.aks_vnet.id
}

# VNet Peering: AKS VNet to App Gateway VNet
resource "azurerm_virtual_network_peering" "aks_to_appgw" {
  name                      = "aks-to-appgw"
  resource_group_name       = "MC_rg-ecommerce-aks_aks-ecommerce-cluster_canadacentral"
  virtual_network_name      = data.azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app_gateway.id
}

# Application Gateway
resource "azurerm_application_gateway" "main" {
  name                = "appgw-ecommerce"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.app_gateway.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  # Backend pools
  backend_address_pool {
    name         = "aks-nodes-pool"
    ip_addresses = ["10.224.0.4", "10.224.0.5"]
  }

  # HTTP settings
  backend_http_settings {
    name                  = "frontend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 31992
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "frontend-probe"
  }

  backend_http_settings {
    name                  = "backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 31908
    protocol              = "Http"
    request_timeout       = 60
  }

  # Health probes
  probe {
    name                = "frontend-probe"
    protocol            = "Http"
    path                = "/"
    host                = "localhost"
    port                = 31992
    interval            = 60
    timeout             = 60
    unhealthy_threshold = 5
  }



  # HTTP listener
  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  # URL path map for routing
  url_path_map {
    name                               = "path-map"
    default_backend_address_pool_name  = "aks-nodes-pool"
    default_backend_http_settings_name = "frontend-http-settings"

    path_rule {
      name                       = "api-rule"
      paths                      = ["/api/*"]
      backend_address_pool_name  = "aks-nodes-pool"
      backend_http_settings_name = "backend-http-settings"
    }
  }

  # Request routing rules
  request_routing_rule {
    name               = "main-rule"
    rule_type          = "PathBasedRouting"
    http_listener_name = "http-listener"
    url_path_map_name  = "path-map"
    priority           = 100
  }

  tags = {
    Environment = "production"
    Project     = "ecommerce"
  }
}

# Output the public IP
output "application_gateway_public_ip" {
  value = azurerm_public_ip.app_gateway.ip_address
}