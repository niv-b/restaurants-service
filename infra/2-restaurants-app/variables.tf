variable "environment" {
  type    = string
}

variable "tags" {
  type    = any
}

variable "aks_cluster_name" {
  type    = string
  description = "AKS cluster name"
}

variable "node_count" {
  type = number
  default = 2
}

variable "vm_size" {
  type = string
  description = "AKS Node Size"
  default = "Standard_D4s_v3"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
  default     = "aks-vnet"
}

variable "address_space" {
  type        = list(string)
  description = "VNET Address Space"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type = string
  description = "Subnet Name"
  default = "aks-subnet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Subnet prefixes"
  default     = ["10.0.0.0/24"]
}

variable "uai_name" {
  type        = string
  description = "Managed Identity Name"
  default     = "aks-restaurants"
}

variable "kv_name" {
  type = string
  description = "Key Vault Name"
}

variable "cosmosdb_account_name" {
  type = string
  description = "Cosmos DB account name"
}

variable "cosmosdb_sqldb_name" {
  type    = string
  default = "restaurantssapp"
}

variable "cosmosdb_container_name" {
  type    = string
  default = "requestslogs"
}

variable "throughput" {
  type = number
  description = "Cosmos DB RU throughput"
  default = 400
}

variable "acr_name" {
  type        = string
  description = "ACR Name"
}

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "eastus"
}

variable "rg_name" {
  type    = string
  description = "Resource Group Name"
}

variable "key_vault_firewall_bypass_ip_cidr" {
  type    = string
  default = null
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU: Standard/Premium"
  default     = "Premium"
}

variable "log_analytics_workspace_location" {
  default = null
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}
