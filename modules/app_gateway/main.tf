resource "azurerm_application_gateway" "app_gateway" {
  name                = "${var.project_prefix}-gateway"
  location            = var.region
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = var.public_ip_id
  }

  frontend_port {
    name = "https"
    port = 443
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "https"
    protocol                       = "Https"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }

  backend_address_pool {
    name = "react-web-pool"
  }

  backend_address_pool {
    name = "service1-pool"
  }

  backend_address_pool {
    name = "service2-pool"
  }

  request_routing_rule {
    name                       = "react-web-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "react-web-pool"
    backend_http_settings_name = "http-settings"
  }

  request_routing_rule {
    name                       = "service1-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "service1-pool"
    backend_http_settings_name = "http-settings"
  }

  request_routing_rule {
    name                       = "service2-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "service2-pool"
    backend_http_settings_name = "http-settings"
  }
}
resource "azurerm_public_ip" "gateway_ip" {
  name                = "${var.project_prefix}-gateway-ip"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
