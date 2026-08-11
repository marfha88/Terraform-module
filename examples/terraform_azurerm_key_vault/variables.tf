variable "name" {
  description = "The name of the Key Vault."
  type        = string
  default     = "example-kv-01"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "The Azure region for the Key Vault."
  type        = string
  default     = "westeurope"
}

variable "tenant_id" {
  description = "The Azure AD tenant ID."
  type        = string
}

variable "sku_name" {
  description = "The SKU of the Key Vault."
  type        = string
  default     = "standard"
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted items."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to the Key Vault."
  type        = map(string)
  default = {
    environment = "example"
  }
}
