# Generate a random 4-character string to ensure globally unique storage account names
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# ---------------------------------------------------------
# 1. The Internal Vault (Premium Block Blobs, Private Only)
# ---------------------------------------------------------
resource "azurerm_storage_account" "vault" {
  name                          = "stobsidianvault${random_string.suffix.result}"
  resource_group_name           = azurerm_resource_group.storage_project_rg.name
  location                      = azurerm_resource_group.storage_project_rg.location
  account_tier                  = "Premium"
  account_replication_type      = "LRS"
  account_kind                  = "BlockBlobStorage"
  public_network_access_enabled = false # Locks out the public internet
}

# The Private Endpoint to connect the Vault to your VNet
resource "azurerm_private_endpoint" "vault_pe" {
  name                = "pe-obsidianstrike-vault"
  location            = azurerm_resource_group.storage_project_rg.location
  resource_group_name = azurerm_resource_group.storage_project_rg.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "psc-vault"
    private_connection_resource_id = azurerm_storage_account.vault.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

# ---------------------------------------------------------
# 2. The Compliance Archive (Standard, WORM Immutability)
# ---------------------------------------------------------
resource "azurerm_storage_account" "archive" {
  name                     = "stobsidianarchive${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.storage_project_rg.name
  location                 = azurerm_resource_group.storage_project_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
}

resource "azurerm_storage_container" "logs" {
  name                  = "compliance-logs"
  storage_account_id    = azurerm_storage_account.archive.id
  container_access_type = "private"
}

# The WORM Policy (Write Once, Read Many) - prevents deletion/edits for 14 days
resource "azurerm_storage_container_immutability_policy" "worm_policy" {
  storage_container_resource_manager_id = azurerm_storage_container.logs.resource_manager_id
  immutability_period_in_days           = 14
  protected_append_writes_all_enabled   = true
}

# ---------------------------------------------------------
# 3. The IT Portal (Standard, Static Website Enabled)
# ---------------------------------------------------------
resource "azurerm_storage_account" "portal" {
  name                     = "stobsidianportal${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.storage_project_rg.name
  location                 = azurerm_resource_group.storage_project_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

# The new v4 resource to enable the static website
resource "azurerm_storage_account_static_website" "portal_website" {
  storage_account_id = azurerm_storage_account.portal.id
  index_document     = "index.html"
  error_404_document = "404.html"
}