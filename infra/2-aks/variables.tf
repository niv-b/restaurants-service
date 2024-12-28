variable "environment" {
  type    = string
}

variable "tags" {
  type    = any
}

variable "cluster_name" {
  type    = string
}

variable "acr_name" {
  type    = string
}

variable "location" {
}

variable "resource_group_name" {
  type    = string
  default = null
}

variable "key_vault_firewall_bypass_ip_cidr" {
  type    = string
  default = null
}

variable "log_analytics_workspace_location" {
  default = null
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}
