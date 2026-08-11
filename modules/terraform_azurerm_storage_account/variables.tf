variable "name" {
  description = "The name of the storage account. Must be globally unique, 3-24 characters, lowercase alphanumeric."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "Storage account name must be 3-24 lowercase alphanumeric characters."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the storage account will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the storage account will be created."
  type        = string
}

variable "account_tier" {
  description = "The tier of the storage account. Valid values: Standard, Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "account_tier must be either 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  description = "The replication type of the storage account. Valid values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "account_replication_type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "min_tls_version" {
  description = "The minimum TLS version for the storage account. Valid values: TLS1_0, TLS1_1, TLS1_2."
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "min_tls_version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "enable_https_traffic_only" {
  description = "Whether to enforce HTTPS-only traffic."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the storage account."
  type        = map(string)
  default     = {}
}
