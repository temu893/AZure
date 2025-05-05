provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# 1.Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

}

# 2. virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 3. subnetA

resource "azurerm_subnet" "subnet_a" {
  name                 = "SubnetA"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}
# 4. subnetB

resource "azurerm_subnet" "subnet_b" {
  name                 = "SubnetB"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

}

# 5.NSG
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

}

# 6.NSG RUle-RDP
resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "Allow-RDP"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.admin_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name

}

# 7.Asspciate NSG with subnetA

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet_a.id
  network_security_group_id = azurerm_network_security_group.nsg.id

}

# 8.Public IP

resource "azurerm_public_ip" "vm_ip" {

  name                = "${var.vm_name}-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

# 9.network Interface

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
  }

}

#10. Windows VM

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_DS1_v2"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]
  computer_name         = var.vm_name
  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

}
# trigger plan


