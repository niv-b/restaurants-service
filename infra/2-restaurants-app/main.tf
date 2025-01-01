data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  location = var.location
  name     = "${var.environment}-${var.rg_name}"
}
