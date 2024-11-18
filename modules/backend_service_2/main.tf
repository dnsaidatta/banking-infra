# Subnet for Backend Service #2
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.project_prefix}-${var.service_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.3.0/24"]
}

# Network Security Group for Backend Service #2
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.project_prefix}-${var.service_name}-nsg"
  location            = var.region
  resource_group_name = var.resource_group_name

  # Inbound rule: Allow HTTPS from the public internet
  security_rule {
    name                       = "allow-https-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
  }

  # Outbound rule: Allow all outbound traffic
  security_rule {
    name                       = "allow-all-outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
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

# Azure API Management for Rate Limiting
resource "azurerm_api_management" "apim" {
  name                = "${var.project_prefix}-${var.service_name}-apim"
  location            = var.region
  resource_group_name = var.resource_group_name
  publisher_name      = "admin@example.com"
  publisher_email     = "admin@example.com"
  sku_name            = "Developer_1" # Use Developer SKU for non-production

  identity {
    type = "SystemAssigned"
  }
}

# API Management API
resource "azurerm_api_management_api" "api" {
  name                = "${var.project_prefix}-${var.service_name}-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Backend Service 2 API"
  path                = "service2"
  protocols           = ["https"]
  service_url         = azurerm_app_service.backend_service.default_site_hostname
}

# Rate Limiting Policy
resource "azurerm_api_management_api_policy" "rate_limit_policy" {
  api_name            = azurerm_api_management_api.api.name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <rate-limit-by-key calls="10" renewal-period="1" counter-key="@(context.Request.IpAddress)" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}
