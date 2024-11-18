output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "frontend_subnet_id" {
  description = "ID of the frontend subnet"
  value       = azurerm_subnet.frontend_subnet.id
}

output "backend_private_subnet_id" {
  description = "ID of the backend private subnet"
  value       = azurerm_subnet.backend_private_subnet.id
}

output "backend_public_subnet_id" {
  description = "ID of the backend public subnet"
  value       = azurerm_subnet.backend_public_subnet.id
}
