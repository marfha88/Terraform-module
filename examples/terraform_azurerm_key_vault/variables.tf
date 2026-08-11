variable "name" {
  description = "Name of the Key Vault."
  type        = string
  default     = "example-kv-001"
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU."
  type        = string
  default     = "standard"
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention in days."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Enable purge protection. Defaults to true; set to false only for non-production Key Vaults."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default = {
    environment = "example"
  }
}
