# Provider block
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.naming_prefix}-webapp"
  location = var.location
}