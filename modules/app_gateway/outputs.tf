output "gateway_url" {
  description = "Public URL for the Application Gateway"
  value       = azurerm_public_ip.gateway_ip.ip_address
}
