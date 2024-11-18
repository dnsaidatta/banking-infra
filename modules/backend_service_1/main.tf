resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "${var.project_prefix}-${var.service_name}-nat-gateway"
  location            = var.region
  resource_group_name = var.resource_group_name
}

# NAT Gateway Public IP
resource "azurerm_public_ip" "nat_gateway_ip" {
  name                = "${var.project_prefix}-${var.service_name}-nat-ip"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Use subnet_id if passed, otherwise create the subnet
resource "azurerm_subnet" "private_subnet" {
  count                = var.subnet_id == "" ? 1 : 0
  name                 = "${var.project_prefix}-${var.service_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.2.0/24"]
}

# Reference either the passed subnet_id or the created subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = var.subnet_id != "" ? var.subnet_id : azurerm_subnet.private_subnet[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# Network Security Group for Backend Service #1
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.project_prefix}-${var.service_name}-nsg"
  location            = var.region
  resource_group_name = var.resource_group_name

  # Inbound rule: Allow traffic from VNet
  security_rule {
    name                       = "allow-vnet-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }

  # Outbound rule: Allow traffic to banking provider IP range
  security_rule {
    name                       = "allow-banking-outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "203.0.113.0/24"
    source_port_range          = "*"
    destination_port_range     = "*"
  }

  # Outbound rule: Allow traffic to private Cosmos DB
  security_rule {
    name                       = "allow-db-outbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.database_ip
    source_port_range          = "*"
    destination_port_range     = "*"
  }
}

# App Service Plan
resource "azurerm_service_plan" "backend_service_plan" {
  name                = "${var.project_prefix}-${var.service_name}-plan"
  location            = var.region
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "S1"
}


# Backend Service App
resource "azurerm_app_service" "backend_service" {
  name                = "${var.project_prefix}-${var.service_name}-app"
  location            = var.region
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_service_plan.backend_service_plan.id

  site_config {
    app_command_line = "npm start"
    linux_fx_version = "NODE|16-lts"
  }

  app_settings = {
    COSMOS_DB_CONNECTION_STRING = var.database_connection_string
  }

  identity {
    type = "SystemAssigned"
  }
}


