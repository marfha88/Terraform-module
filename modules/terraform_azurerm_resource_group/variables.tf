variable "name" {
  description = "The name of the resource group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._\\-()]{1,90}$", var.name))
    error_message = "Resource group name must be 1-90 characters and contain only alphanumeric characters, periods, underscores, hyphens, and parentheses."
  }
}

variable "location" {
  description = "The Azure region where the resource group will be created."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource group."
  type        = map(string)
  default     = {}
}
