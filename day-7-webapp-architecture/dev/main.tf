provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# NETWORK MODULE
module "network" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_cidr           = var.vnet_cidr
  web_subnet_cidr     = var.web_subnet_cidr
  app_subnet_cidr     = var.app_subnet_cidr
  db_subnet_cidr      = var.db_subnet_cidr
  admin_ip            = var.admin_ip
}

#PUBLIC IP FOR VM

resource "azurerm_public_ip" "vm_ip" {
  name                = "vm-web-publicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Basic"

}

#NETWORK INTERFACE FOR VM

resource "azurerm_network_interface" "vm_nic" {
  name                = "vm-web-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "webipconfig"
    subnet_id = module.network.web_subnet_id
    private_ip_address_allocation = "Dymamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip
  }

}

# LINUX VM IN WEB SUBNET

resource "azurerm_linux_virtual_machine" "web_vm" {
  name                            = "vm-web"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "vm-web-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

