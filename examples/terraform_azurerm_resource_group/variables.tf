variable "name" {
  description = "Name of the resource group."
  type        = string
  default     = "example-rg"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default = {
    environment = "example"
  }
}
