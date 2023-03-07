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

  site_config {
    always_on = true

    application_stack {
      docker_image     = "${azurerm_container_registry.acr.login_server}/todolist"
      docker_image_tag = "latest"
    }
  }


  app_settings = {
    DOCKER_REGISTRY_SERVER_URL      = azurerm_container_registry.acr.login_server
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
    MYSQL_HOST                      = azurerm_mysql_flexible_server.mysql.fqdn
    MYSQL_DB                        = azurerm_mysql_flexible_database.todos.name
    MYSQL_PASSWORD                  = random_password.database_password.result
    MYSQL_USER                      = var.administrator_login
  }


}