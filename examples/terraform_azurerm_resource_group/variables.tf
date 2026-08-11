variable "name" {
  description = "The name of the resource group."
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "The Azure region for the resource group."
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "Tags to apply to the resource group."
  type        = map(string)
  default = {
    environment = "example"
  }
}
