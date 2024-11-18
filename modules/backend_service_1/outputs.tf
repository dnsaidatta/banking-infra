output "app_service_url" {
  description = "Public URL of Backend Service 1"
  value       = azurerm_app_service.backend_service.default_site_hostname
}

output "subnet_id" {
  description = "Subnet ID for Backend Service 1"
  value       = azurerm_subnet.private_subnet[0].id
}


output "nsg_id" {
  description = "Network Security Group ID for Backend Service 1"
  value       = azurerm_network_security_group.nsg.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = azurerm_nat_gateway.nat_gateway.id
}
