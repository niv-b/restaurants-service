variable "environment" {
  type    = string
}

variable "identity_rg_name" {
  description = "The name of the resource group in which the user-assigned managed identity will be created."
}

variable "location" {
  description = "The location where the resources will be created."
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}

variable "gh_uai_name" {
  description = "The name of the user-assigned managed identity that's used for GitHub Actions"
  type        = string
}

variable "github_organization_target" {
  type        = string
  description = "The name of the GitHub organization to target"
}

variable "github_repository" {
  type        = string
  description = "The name of the GitHub repository to target"
}

variable "owner_role_name" {
  type        = string
  default     = "Owner"
  description = "The name of the Owner role given to the user-assigned identity"
}
