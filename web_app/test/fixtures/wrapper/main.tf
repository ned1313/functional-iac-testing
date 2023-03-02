module "webapp" {
  source = "../../../"

  vmss_source_image = var.vmss_source_image
  vmss_admin_username = var.vmss_admin_username
}