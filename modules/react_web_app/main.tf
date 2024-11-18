resource "azurerm_service_plan" "react_web_plan" {
  name                = "${var.project_prefix}-react-web-plan"
  location            = var.region
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_app_service" "react_web_app" {
  name                = "${var.project_prefix}-react-web-app"
  location            = var.region
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_service_plan.react_web_plan.id

  site_config {
    app_command_line = "npm start"
    linux_fx_version = "NODE|16-lts"
  }

  app_settings = {
    API_URL = var.api_url
  }

  identity {
    type = "SystemAssigned"
  }
}
