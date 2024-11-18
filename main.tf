# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.region
}

# Virtual Network Module
module "vnet" {
  source              = "./modules/vnet"
  project_prefix      = var.project_prefix
  region              = var.region
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = "${var.project_prefix}-gateway-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "backend_service_1" {
  source                     = "./modules/backend_service_1"
  project_prefix             = var.project_prefix
  region                     = var.region
  resource_group_name        = azurerm_resource_group.main.name
  vnet_name                  = module.vnet.vnet_name
  subnet_id                  = module.vnet.backend_private_subnet_id
  database_ip                = module.cosmos_db_service1.private_ip
  service_name               = "service1"
  database_connection_string = module.cosmos_db_service1.connection_string
}



module "backend_service_2" {
  source                     = "./modules/backend_service_2"
  project_prefix             = var.project_prefix
  region                     = var.region
  resource_group_name        = azurerm_resource_group.main.name
  vnet_name                  = module.vnet.vnet_name
  service_name               = "service2"
  database_connection_string = module.cosmos_db_service2.connection_string
}
# Cosmos DB for Backend Service 1
module "cosmos_db_service1" {
  source              = "./modules/cosmos_db"
  project_prefix      = var.project_prefix
  region              = var.region
  resource_group_name = azurerm_resource_group.main.name
  service_name        = "service1"
  database_private    = true
  private_subnet_id   = module.vnet.backend_private_subnet_id
}


# Cosmos DB for Backend Service 2
module "cosmos_db_service2" {
  source              = "./modules/cosmos_db"
  project_prefix      = var.project_prefix
  region              = var.region
  resource_group_name = azurerm_resource_group.main.name
  service_name        = "service2"
  database_private    = false
}


module "react_web_app" {
  source              = "./modules/react_web_app"
  project_prefix      = var.project_prefix
  region              = var.region
  resource_group_name = azurerm_resource_group.main.name
  api_url             = module.backend_service_2.app_service_url
}


# Application Gateway
module "app_gateway" {
  source              = "./modules/app_gateway"
  project_prefix      = var.project_prefix
  region              = var.region
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.vnet.frontend_subnet_id
  public_ip_id        = azurerm_public_ip.app_gateway_public_ip.id
  react_web_app_fqdn  = module.react_web_app.web_app_url
  api_service1_fqdn   = module.backend_service_1.app_service_url
  api_service2_fqdn   = module.backend_service_2.app_service_url
}

