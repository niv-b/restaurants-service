resource "azurerm_resource_group" "main" {
  location = var.location
  name     = "${var.environment}-${var.resource_group_name}"
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "9.3.0"

  prefix                               = "prefix-${random_id.prefix.hex}"
  resource_group_name                  = local.resource_group.name
  cluster_name                         = "${var.environment}-${var.cluster_name}"
  disk_encryption_set_id               = azurerm_disk_encryption_set.des.id
  kubernetes_version        = "1.30"
  attached_acr_id_map = {
    resturnats = azurerm_container_registry.resturnats.id
  }
  network_plugin  = "azure"
  network_policy  = "azure"
  os_disk_size_gb = 60
  vnet_subnet_id  = azurerm_subnet.test.id

  tags = var.tags
}
