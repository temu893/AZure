terraform {
  required_version = ">= 1.3.0"

  backend "azurerm" {
    resource_group_name  = "TemDevOps"
    storage_account_name = "temdevopsstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_cidr           = "10.1.0.0/16"
  subnet_cidrs        = ["10.1.1.0/24", "10.1.2.0/24"]
  admin_ip            = var.admin_ip
}
