resource "azurerm_network_security_group" "frontend_nsg" {
  name                = "${var.project_prefix}-frontend-nsg"
  location            = var.region
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_group" "internal_backend_nsg" {
  name                = "${var.project_prefix}-internal-backend-nsg"
  location            = var.region
  resource_group_name = var.resource_group_name

  # Outbound rule to allow only the bank's IP range
  security_rule {
    name                       = "AllowBankIPs"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "203.0.113.0/24"
  }

  # Outbound rule to deny all other internet traffic
  security_rule {
    name                       = "DenyAllOutboundInternet"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_group" "public_backend_nsg" {
  name                = "${var.project_prefix}-public-backend-nsg"
  location            = var.region
  resource_group_name = var.resource_group_name
}
