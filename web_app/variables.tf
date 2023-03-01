variable "naming_prefix" {
  type        = string
  description = "(Optional) The prefix to use for all resources in this example. Defaults to hcp."
  default     = "nsb"
}

variable "location" {
  type        = string
  description = "(Optional) Azure location for resources. Defaults to West US."
  default     = "westus"
}

variable "address_space" {
  type        = list(string)
  description = "(Optional) The address space that is used by the virtual network. Defaults to [10.0.0.0/16]"
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "(Optional) List of address prefixes to use for the subnets. Defaults to two subnets."
  default = [
    "10.0.0.0/24",
    "10.0.1.0/24",
  ]
}

variable "subnet_names" {
  type        = list(string)
  description = "(Optional) List of subnet names. Defaults to two subnets: workers and clients."
  default = [
    "webapps",
    "clients",
  ]
}

variable "web_vm_size" {
  type        = string
  description = "(Optional) The size of the VMs to create. Defaults to Standard_D2s_v3."
  default     = "Standard_D2s_v3"
}

variable "web_vm_count" {
  type        = number
  description = "(Optional) The number of worker VMs to create. Defaults to 1."
  default     = 1
}

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

variable "vmss_os_disk_storage_account_type" {
  type        = string
  description = "The storage account type of the VMSS OS disk"
  default     = "StandardSSD_LRS"
}

variable "vmss_os_disk_caching" {
  type        = string
  description = "The caching type of the VMSS OS disk"
  default     = "ReadWrite"
}

variable "vmss_zones" {
  type        = list(string)
  description = "The zones of the VMSS"
  default     = null
}

variable "vmss_range" {
  type = object({
    min = number
    max = number
  })
  description = "(Optional) The range of the VMSS Instances. Defaults to 1-4."
  default = {
    min = 1
    max = 4
  }
}