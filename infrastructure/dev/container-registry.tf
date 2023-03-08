resource "azurerm_container_registry" "acr" {
  name                          = "cr${var.owner}${var.project}${var.environment}001"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  public_network_access_enabled = true
  sku                           = "Premium"
  admin_enabled                 = true
}


# Store container registry credentials in key vault
resource "azurerm_key_vault_secret" "container_registry_admin_username" {
  name         = "cradminusername"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.defined_access_policy]
}

resource "azurerm_key_vault_secret" "container_registry_admin_password" {
  name         = "cradminpassword"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.defined_access_policy]
}