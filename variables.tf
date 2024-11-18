variable "resource_group_name" {
  description = "The name of the resource group to create"
  type        = string
  default     = "banking-solution-rg"
}

variable "region" {
  description = "Azure region for resources"
  type        = string
  default     = "West Europe"
}

variable "project_prefix" {
  description = "Prefix for resource naming"
  type        = string
  default     = "bankingapp"
}

variable "allowed_ips" {
  description = "Allowed IPs for backend service #1 outbound"
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

variable "rate_limit" {
  description = "Rate limit for backend service #2"
  type        = number
  default     = 10
}
