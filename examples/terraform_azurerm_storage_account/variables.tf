variable "name" {
  description = "Name of the storage account."
  type        = string
  default     = "examplestorage001"
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

variable "account_tier" {
  description = "Storage tier."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default = {
    environment = "example"
  }
}
