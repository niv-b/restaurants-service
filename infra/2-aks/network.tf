resource "random_id" "prefix" {
  byte_length = 8
}

resource "azurerm_virtual_network" "test" {
  address_space       = ["10.52.0.0/16"]
  location            = var.location
  name                = "${random_id.prefix.hex}-vn"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "test" {
  address_prefixes     = ["10.52.0.0/24"]
  name                 = "${random_id.prefix.hex}-sn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.test.name
}
