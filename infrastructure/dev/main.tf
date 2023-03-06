terraform {
  required_version = "=1.3.9"
  backend "azurerm" {
  }
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}