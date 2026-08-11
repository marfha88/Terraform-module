variable "name" {
  description = "The name of the storage account."
  type        = string
  default     = "examplestorage001"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "The Azure region for the storage account."
  type        = string
  default     = "westeurope"
}

variable "account_tier" {
  description = "The tier of the storage account."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags to apply to the storage account."
  type        = map(string)
  default = {
    environment = "example"
  }
}
