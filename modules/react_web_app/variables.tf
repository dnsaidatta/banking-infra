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

variable "api_url" {
  description = "URL of the backend API consumed by the React Web App"
  type        = string
}
