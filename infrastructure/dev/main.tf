terraform {
  required_version = "=1.3.9"
  backend "azurerm" {
  }
}


provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}

# Key vault
resource "azurerm_key_vault" "kv" {
  name                        = "kv${var.owner}${var.project}${var.environment}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = var.keyvault_sku

  # ! Allowing access from all networks
  network_acls {
    default_action             = "Allow"
    bypass                     = "AzureServices"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = var.tags
}

# Key vault access policies for users
resource "azurerm_key_vault_access_policy" "defined_access_policy" {
  for_each     = toset(concat(var.object_ids, [data.azurerm_client_config.current.object_id]))
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value

  key_permissions = [
    "Get", "Update", "Delete", "List", "Encrypt", "Decrypt",
  ]

  secret_permissions = [
    "Get", "Delete", "List", "Set", "Recover", "Backup", "Restore", "Purge"
  ]
}