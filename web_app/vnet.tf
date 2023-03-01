module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "~> 2.0"
  resource_group_name = azurerm_resource_group.main.name
  vnet_name           = azurerm_resource_group.main.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names

  depends_on = [
    azurerm_resource_group.main
  ]
}