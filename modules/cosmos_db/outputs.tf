output "connection_string" {
  description = "Primary connection string for the Cosmos DB"
  value       = azurerm_cosmosdb_account.cosmos_db.connection_strings[0]
}

output "private_ip" {
  description = "Private IP of the Cosmos DB (if private)"
  value       = azurerm_private_endpoint.private_endpoint[0].private_service_connection[0].private_ip_address
}

