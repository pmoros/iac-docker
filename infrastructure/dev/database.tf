# Credentials
resource "random_password" "database_password" {
  length           = 16
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
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

# Disable secure transport
resource "azurerm_mysql_flexible_server_configuration" "mysql" {
  server_name         = azurerm_mysql_flexible_server.mysql.name
  resource_group_name = azurerm_resource_group.rg.name
  name                = "disable_secure_transport"
  value               = "OFF"
}