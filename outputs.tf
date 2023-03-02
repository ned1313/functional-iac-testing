output "lb_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "lb_fqdn" {
  value = azurerm_public_ip.main.fqdn
}