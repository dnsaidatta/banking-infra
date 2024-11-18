output "web_app_url" {
  description = "React Web App URL"
  value       = azurerm_app_service.react_web_app.default_site_hostname
}
