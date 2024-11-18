resource "azurerm_cosmosdb_account" "cosmos_db" {
  name                = "${var.project_prefix}-${var.service_name}-db"
  location            = var.region
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  geo_location {
    location          = var.region
    failover_priority = 0
  }

  consistency_policy {
    consistency_level = "Session"
  }

  public_network_access_enabled = !var.database_private
}

# Create Private Endpoint if database_private is true
resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.database_private ? 1 : 0
  name                = "${var.project_prefix}-${var.service_name}-db-private-endpoint"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "cosmosdb-private-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmos_db.id
    is_manual_connection           = false
  }
}
