variable "project_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "service_name" {
  description = "Service name for which the Cosmos DB is created"
  type        = string
}

variable "database_private" {
  description = "Flag to indicate if the database should have a private endpoint"
  type        = bool
  default     = false
}

variable "private_subnet_id" {
  description = "Subnet ID for the private Cosmos DB endpoint"
  type        = string
  default     = null
}
