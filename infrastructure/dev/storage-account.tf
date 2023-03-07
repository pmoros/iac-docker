resource "azurerm_storage_account" "st" {
  name                     = "st${var.owner}${var.project}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}