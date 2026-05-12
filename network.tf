# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-obsidianstrike-core" # Name of the virtual network 
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.storage_project_rg.location
  resource_group_name = azurerm_resource_group.storage_project_rg.name
}

# Subnet specifically for private endpoints
resource "azurerm_subnet" "pe_subnet" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.storage_project_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}