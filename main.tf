# The main resource group
resource "azurerm_resource_group" "storage_project_rg" {
  name     = "rg-enterprise-storage-project"
  location = var.location
}