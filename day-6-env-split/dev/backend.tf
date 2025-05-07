terraform {
  backend "azurerm" {
    resource_group_name  = "TemDevOps"
    storage_account_name = "temdevopsstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

