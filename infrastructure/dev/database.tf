# Credentials
resource "random_password" "database_password" {
  length           = 8
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create mysql server
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "sqldb-${var.project}-${var.environment}-${var.location}"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location
  administrator_login    = var.administrator_login
  administrator_password = random_password.database_password.result
  zone                   = var.database_zone
  version                = "8.0.21"
  identity {
    type = "SystemAssigned"
  }
  sku_name = var.database_sku
  tags     = var.tags
}

# Disable secure transport
resource "azurerm_mysql_flexible_server_configuration" "mysql" {
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = azurerm_resource_group.rg.name
  name                = "require_secure_transport"
  value               = "OFF"
}

# Store database credentials in key vault
resource "azurerm_key_vault_secret" "db_username" {
  name         = "dbusername"
  value        = var.administrator_login
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.defined_access_policy]
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "dbpassword"
  value        = random_password.database_password.result
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.defined_access_policy]
}

# Create database
resource "azurerm_mysql_flexible_database" "todos" {
  name                = "todos"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}