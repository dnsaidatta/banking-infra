output "app_service_url" {
  description = "Public URL of Backend Service 2"
  value       = azurerm_app_service.backend_service.default_site_hostname
}

output "subnet_id" {
  description = "Subnet ID for Backend Service 2"
  value       = azurerm_subnet.public_subnet.id
}

output "nsg_id" {
  description = "Network Security Group ID for Backend Service 2"
  value       = azurerm_network_security_group.nsg.id
}

output "apim_url" {
  description = "URL of the Azure API Management for Backend Service 2"
  value       = azurerm_api_management.apim.gateway_url
}
