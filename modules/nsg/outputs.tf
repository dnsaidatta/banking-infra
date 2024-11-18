output "frontend_nsg_id" {
  description = "ID of the frontend NSG"
  value       = azurerm_network_security_group.frontend_nsg.id
}

output "internal_backend_nsg_id" {
  description = "ID of the internal backend NSG"
  value       = azurerm_network_security_group.internal_backend_nsg.id
}

output "public_backend_nsg_id" {
  description = "ID of the public backend NSG"
  value       = azurerm_network_security_group.public_backend_nsg.id
}
