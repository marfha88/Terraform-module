variable "name" {
  description = "The name of the Key Vault. Must be globally unique, 3-24 characters, alphanumeric and hyphens, start with a letter."
  type        = string

  validation {
    condition     = var.name == null ? true : can(regex("^[a-zA-Z](?!.*--)[a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$", var.name))
    error_message = "Key Vault name must be 3-24 characters, start with a letter, end with a letter or digit, contain only alphanumeric characters and hyphens, and must not contain consecutive hyphens."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Key Vault will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault will be created."
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID for the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "The SKU of the Key Vault. Valid values: standard, premium."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either 'standard' or 'premium'."
  }
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for the Key Vault."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "The number of days that soft-deleted items are retained. Must be between 7 and 90."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Key Vault."
  type        = map(string)
  default     = {}
}
