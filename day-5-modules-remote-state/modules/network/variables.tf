variable "vnet_cidr" {}
variable "subnet_cidrs" {
  type = list(string)
}
variable "resource_group_name" {}
variable "location" {}
variable "admin_ip" {}
