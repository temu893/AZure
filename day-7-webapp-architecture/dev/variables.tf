variable "resource_group_name" {
  type    = string
}
variable "location" {
  type    = string
  default = "centralus"

}
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID to deploy into"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}
variable "vnet_name" {
  type        = string
  description = "name of the virtual network"
  default     = "MyVnet"

}
variable "vnet_address_space" {
  type        = string
  description = "CIDR range for the VNet"
  default     = "10.0.0.0/16"
}

variable "nsg_name" {
  type        = string
  description = "Name of the network security group"
  default     = "MyNSG"

}
variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
  default     = "MyWindowVM"

}
variable "admin_username" {
  type        = string
  description = "admin user for the VM"

}
variable "admin_password" {
  type        = string
  description = "Admin password for the vm"
  sensitive   = true

}
variable "admin_ip" {
  type        = string
  description = "public ip in CIDR format for RDO access"
}
variable "vnet_cidr" {
  description = "CIDR range for VNet"
  type        = string
}
variable "web_subnet_cidr" {}
variable "app_subnet_cidr" {}
variable "db_subnet_cidr" {}
