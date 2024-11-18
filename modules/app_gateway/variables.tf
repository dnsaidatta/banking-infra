variable "project_prefix" {
  description = "Project prefix for naming resources"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Application Gateway"
  type        = string
}

variable "react_web_app_fqdn" {
  description = "FQDN of the React Web App"
  type        = string
}

variable "api_service1_fqdn" {
  description = "FQDN of Backend Service #1"
  type        = string
}

variable "api_service2_fqdn" {
  description = "FQDN of Backend Service #2"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the public IP for the Application Gateway"
  type        = string
}
