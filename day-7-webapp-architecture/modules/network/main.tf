resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}
#Named subnets
resource "azurerm_subnet" "web" {
  name                = "web"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [var.web_subnet_cidr]
}
resource "azurerm_subnet" "app" {
  name                = "app"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [var.app_subnet_cidr]
}
resource "azurerm_subnet" "db" {
  name                = "db"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes    = [var.db_subnet_cidr]
}

#NSGs
resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "db" {
  name                = "nsg-db"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_http_from_internet_to_web" {
  name                        = "allow_http_from_internet_to_web"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web.name
}
#This rule is attached to the App NSG, and it allows inbound traffic coming from the Web subnet on port 8080.
resource "azurerm_network_security_rule" "allow_app_inbound_from_web" {
  name                        = "allow_app_inbound_from_web"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = var.web_subnet_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}

resource "azurerm_network_security_rule" "allow_db_inbound_from_app" {
  name                        = "allow_db_inbound_from_app"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = var.app_subnet_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.db.name
}


# Associate NSGs to subnets

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}
resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}