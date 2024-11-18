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

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the backend service"
  type        = string
}

variable "database_ip" {
  description = "Private IP of the associated database"
  type        = string
}

variable "service_name" {
  description = "Name of the backend service"
  type        = string
}

variable "database_connection_string" {
  description = "Connection string for the Cosmos DB"
  type        = string
}
