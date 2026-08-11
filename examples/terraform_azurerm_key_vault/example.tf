module "key_vault" {
  source = "../../modules/terraform_azurerm_key_vault"

  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  purge_protection_enabled   = var.purge_protection_enabled
  soft_delete_retention_days = var.soft_delete_retention_days
  tags                       = var.tags
  rbac_authorization_enabled = true
}
