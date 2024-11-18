output "react_web_app_url" {
  description = "URL of the React Web App"
  value       = module.react_web_app.web_app_url
}

output "backend_service_1_url" {
  description = "Public URL of Backend Service 1"
  value       = module.backend_service_1.app_service_url
}

output "backend_service_1_db" {
  description = "Cosmos DB endpoint for Backend Service 1"
  value       = module.cosmos_db_service1.connection_string
}

output "backend_service_2_url" {
  description = "Public URL of Backend Service 2"
  value       = module.backend_service_2.app_service_url
}

output "backend_service_2_db" {
  description = "Cosmos DB endpoint for Backend Service 2"
  value       = module.cosmos_db_service2.connection_string
}
