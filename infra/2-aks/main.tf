resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "${var.environment}-restaurants-aks"
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "9.3.0"

  prefix                               = "prefix-${random_id.prefix.hex}"
  resource_group_name                  = azurerm_resource_group.main.name
  cluster_name                         = "${var.environment}-${var.cluster_name}"
  kubernetes_version        = "1.30"
  attached_acr_id_map = {
    restaurants = azurerm_container_registry.restaurants.id
  }
  network_plugin  = "azure"
  network_policy  = "azure"
  rbac_aad        = false
  os_disk_size_gb = 60
  vnet_subnet_id  = azurerm_subnet.test.id

  tags = var.tags

  depends_on = [
    azurerm_resource_group.main
  ]
}
