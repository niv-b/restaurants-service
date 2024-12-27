resource "azurerm_container_registry" "restaurants" {
  name                = "${var.environment}-${var.acr_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Premium"
}
