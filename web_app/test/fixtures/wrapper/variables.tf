variable "vmss_admin_username" {
  type        = string
  description = "(Required) The admin username of the VMSS"
}

variable "vmss_source_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Values for the source image of the VMSS"
}