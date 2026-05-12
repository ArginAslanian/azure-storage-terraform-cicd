# ---------------------------------------------------------
# 1. Internal Vault Access
# ---------------------------------------------------------

# Grant the Admin Group full data access to the Vault
resource "azurerm_role_assignment" "admin_vault_access" {
  scope                = azurerm_storage_account.vault.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.admin_group_object_id
}

# Grant the Reader Group read-only data access to the Vault
resource "azurerm_role_assignment" "reader_vault_access" {
  scope                = azurerm_storage_account.vault.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.reader_group_object_id
}

# ---------------------------------------------------------
# 2. Compliance Archive Access
# ---------------------------------------------------------

# Grant the Admin Group data access to the Archive so they can write logs.
# Note: Because we applied a WORM policy in storage.tf, even with "Contributor" 
# rights, Azure will physically block them from deleting or altering the logs for 14 days.
resource "azurerm_role_assignment" "admin_archive_access" {
  scope                = azurerm_storage_account.archive.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.admin_group_object_id
}

# Grant the Reader Group visibility of the Resource Group in the portal
resource "azurerm_role_assignment" "reader_rg_visibility" {
  scope                = azurerm_resource_group.storage_project_rg.id
  role_definition_name = "Reader"
  principal_id         = var.reader_group_object_id
}