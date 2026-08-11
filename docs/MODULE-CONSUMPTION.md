# Module Consumption Guide

This guide explains how to consume modules from this monorepo in your own Terraform configurations.

## Using a Module via Git Source

Pin to a specific release tag to ensure reproducibility:

```hcl
module "resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_resource_group?ref=v1.0.0"

  name     = "myapp-prod-rg"
  location = "eastus"
  tags = {
    environment = "prod"
    team        = "platform"
  }
}
```

> **Always** pin to a tag (`?ref=vX.Y.Z`). Never use `?ref=main` in production.

## Discovering Available Modules

Browse the [`modules/`](../modules/) directory. Each sub-folder is a self-contained module.

## Required Providers

Each module declares its required provider versions in `versions.tf`.
Your root configuration must configure the `azurerm` provider:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

## Upgrade Path

1. Check the [Releases](https://github.com/marfha88/Terraform-module/releases) page for changelogs.
2. Update the `?ref=` pin to the new tag.
3. Run `terraform init -upgrade` then `terraform plan` to review the diff.
