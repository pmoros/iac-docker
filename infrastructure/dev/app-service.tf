resource "azurerm_service_plan" "service_plan" {
  name                = "sp-${var.project}-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = var.web_app_sku_name
  os_type             = "Linux"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "wa-${var.project}-${var.environment}-${var.location}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.service_plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true

    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/todolist"
      docker_image_tag = "latest"
    }
  }


  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.kv.vault_uri}secrets/cradminusername/)"
    DOCKER_REGISTRY_SERVER_PASSWORD = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.kv.vault_uri}secrets/cradminpassword/)"
    MYSQL_HOST                      = azurerm_mysql_flexible_server.mysql.fqdn
    MYSQL_DB                        = azurerm_mysql_flexible_database.todos.name
    MYSQL_USER                      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.kv.vault_uri}secrets/dbusername/)"
    MYSQL_PASSWORD                  = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.kv.vault_uri}secrets/dbpassword/)"
    WEBSITES_PORT                   = var.web_app_port
  }

  depends_on = [
    azurerm_key_vault_secret.container_registry_admin_username,
    azurerm_key_vault_secret.container_registry_admin_password,
    azurerm_key_vault_secret.db_username,
    azurerm_key_vault_secret.db_password
  ]

}


resource "azurerm_mysql_flexible_server_firewall_rule" "mysql_rule" {
  name                = "azure_services_public_access"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}