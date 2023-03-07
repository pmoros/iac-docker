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

# Credentials
resource "random_password" "database_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
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

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = var.tags
}