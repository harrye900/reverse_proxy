output "resource_group_name" {
  value = data.azurerm_resource_group.ecommerce.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.ecommerce.name
}

output "container_registry_name" {
  value = azurerm_container_registry.ecommerce.name
}

output "container_registry_login_server" {
  value = azurerm_container_registry.ecommerce.login_server
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.ecommerce.kube_config_raw
  sensitive = true
}