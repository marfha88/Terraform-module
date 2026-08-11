module "resource_group" {
  source = "../../modules/terraform_azurerm_resource_group"

  name     = var.name
  location = var.location
  tags     = var.tags
}
