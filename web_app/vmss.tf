
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_security_group" "main" {
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  name                = "${var.naming_prefix}-vmss-nsg"
}

resource "azurerm_network_security_rule" "http_in" {
  name                        = "web-client-inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = var.subnet_prefixes[0]
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  name                            = "${var.naming_prefix}-vmss"
  sku                             = var.web_vm_size
  instances                       = var.web_vm_count
  admin_username                  = var.vmss_admin_username
  disable_password_authentication = true
  upgrade_mode                    = "Automatic"

  admin_ssh_key {
    username   = var.vmss_admin_username
    public_key = tls_private_key.main.public_key_openssh
  }

  source_image_reference {
    publisher = var.vmss_source_image.publisher
    offer     = var.vmss_source_image.offer
    sku       = var.vmss_source_image.sku
    version   = var.vmss_source_image.version
  }

  os_disk {
    storage_account_type = var.vmss_os_disk_storage_account_type
    caching              = var.vmss_os_disk_caching
  }

  zones = var.vmss_zones

  network_interface {
    name                      = "${var.naming_prefix}-vmss-nic"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.main.id

    ip_configuration {
      name                                   = "${var.naming_prefix}-vmss-ip-config"
      primary                                = true
      subnet_id                              = module.vnet.vnet_subnets[0]
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.main.id]
    }
  }

  termination_notification {
    enabled = true
    timeout = "PT5M"
  }

  custom_data = base64encode(file("${path.module}/web_install.tmpl"))

  health_probe_id = azurerm_lb_probe.main.id

  depends_on = [
    azurerm_lb_rule.main
  ]

}

# Azure Load Balancer
resource "azurerm_public_ip" "main" {
  name                = "${var.naming_prefix}-lbpip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "main" {
  name                = "${var.naming_prefix}-webapp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.naming_prefix}-lb-fe"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

# Azure Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "WebBEPool"
}

# Azure Load Balancer Health Probe
resource "azurerm_lb_probe" "main" {
  name            = "${var.naming_prefix}-web"
  loadbalancer_id = azurerm_lb.main.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

# Azure Load Balancer Rule
resource "azurerm_lb_rule" "main" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "Http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "${var.naming_prefix}-lb-fe"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.main.id,
  ]
  probe_id = azurerm_lb_probe.main.id
}
