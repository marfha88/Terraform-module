# Module Consumption Guide

This guide explains how to consume Terraform modules from this repository.

## Referencing a Module via Git Source

Use the double-slash (`//`) separator to point at a subdirectory inside the repo, and pin the version with `?ref=`:

```hcl
module "storage_account" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_storage_account?ref=v1.0.0"

  name                     = "myappstorage001"
  resource_group_name      = "myapp-prod-rg"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "prod"
    owner       = "platform-team"
  }
}
```

## Initialising

```bash
terraform init
terraform plan
terraform apply
```

## Pinning Versions

Always pin to a specific tag (e.g. `?ref=v1.0.0`) in production configurations. Avoid `?ref=main` as it can cause unexpected changes when the repo is updated.

## Available Modules

| Module | Path |
|--------|------|
| Resource Group | `modules/terraform_azurerm_resource_group` |
| Storage Account | `modules/terraform_azurerm_storage_account` |

## Upgrading

To upgrade to a new module version, update the `?ref=` value and re-run `terraform init -upgrade`.
