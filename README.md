# Terraform Module Monorepo

![CI](https://github.com/marfha88/Terraform-module/actions/workflows/terraform-module-ci.yml/badge.svg)
![License](https://img.shields.io/github/license/marfha88/Terraform-module)
![Latest Release](https://img.shields.io/github/v/release/marfha88/Terraform-module)

A monorepo of reusable Azure Terraform modules. Each module is self-contained, versioned together via Git tags, and consumable directly from this repository without a private registry.

---

## Table of Contents

- [Overview](#overview)
- [Available Modules](#available-modules)
- [Repository Structure](#repository-structure)
- [Consuming a Module](#consuming-a-module)
- [Module Authoring Standards](#module-authoring-standards)
- [Local Development](#local-development)
- [Versioning](#versioning)
- [Contributing](#contributing)

---

## Overview

This repository provides a collection of opinionated, production-ready Terraform modules for Azure resources. Modules are designed to be:

- **Reusable** — generic inputs and outputs, no environment-specific hardcoding
- **Secure by default** — sensible defaults (TLS 1.2, purge protection, HTTPS-only)
- **Validated** — `validation` blocks on all critical inputs
- **Consumable from Git** — no Terraform Registry required; pin with `?ref=vX.Y.Z`

---

## Available Modules

| Module | Description | Source Path |
|--------|-------------|-------------|
| `terraform_azurerm_resource_group` | Azure Resource Group | `modules/terraform_azurerm_resource_group` |
| `terraform_azurerm_storage_account` | Azure Storage Account | `modules/terraform_azurerm_storage_account` |
| `terraform_azurerm_key_vault` | Azure Key Vault | `modules/terraform_azurerm_key_vault` |

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── terraform-module-ci.yml       # fmt, init, validate on PR/push
│       └── terraform-module-release.yml  # GitHub Release on semver tag push
├── docs/
│   ├── MODULE-CONSUMPTION.md             # How to consume modules
│   ├── MODULE-PUBLISHING.md              # How to author and publish modules
│   └── GITHUB-APP-CONSUMPTION.md         # Consuming via a GitHub App token
├── modules/
│   ├── terraform_azurerm_resource_group/
│   ├── terraform_azurerm_storage_account/
│   └── terraform_azurerm_key_vault/
└── examples/
    ├── terraform_azurerm_resource_group/
    ├── terraform_azurerm_storage_account/
    └── terraform_azurerm_key_vault/
```

Each module folder contains:

| File | Purpose |
|------|---------|
| `versions.tf` | Terraform and provider version constraints |
| `variables.tf` | Input declarations with validation |
| `locals.tf` | Derived/computed values |
| `main.tf` | Resource declarations |
| `outputs.tf` | Output declarations |

Each example folder contains:

| File | Purpose |
|------|---------|
| `common.tf` | Provider configuration |
| `example.tf` | Module call |
| `variables.tf` | Example inputs with defaults |
| `outputs.tf` | Example outputs |

---

## Consuming a Module

Reference any module directly from this repo using a Git source with a version tag:

```hcl
module "resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_resource_group?ref=v1.0.0"

  name     = "myapp-prod-rg"
  location = "westeurope"
  tags     = { environment = "prod" }
}
```

```hcl
module "storage_account" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_storage_account?ref=v1.0.0"

  name                     = "myappstorage001"
  resource_group_name      = module.resource_group.name
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = { environment = "prod" }
}
```

```hcl
module "key_vault" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_key_vault?ref=v1.0.0"

  name                = "myapp-kv-prod"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  tenant_id           = var.tenant_id
  tags                = { environment = "prod" }
}
```

> **Always pin to a specific tag** (e.g. `?ref=v1.0.0`) in production. Avoid `?ref=main` to prevent unexpected changes.

For detailed guidance see [docs/MODULE-CONSUMPTION.md](docs/MODULE-CONSUMPTION.md).

---

## Module Authoring Standards

- Terraform `>= 1.6` and `azurerm ~> 3.0` in every `versions.tf`.
- Provider configuration lives in **examples only** — never inside a module.
- Add `validation` blocks on all critical variables (names, enums, numeric ranges).
- Mark sensitive outputs with `sensitive = true`.
- Use `locals.tf` to compute derived values; keep `main.tf` clean.
- No hardcoded secrets, subscription IDs, or tenant IDs.
- Always run `terraform fmt -recursive` before committing.

For the full authoring guide see [docs/MODULE-PUBLISHING.md](docs/MODULE-PUBLISHING.md).

---

## Local Development

```bash
# Check formatting
terraform fmt -check -recursive

# Initialise without a remote backend
terraform init -backend=false

# Validate configuration
terraform validate

# Plan against a real Azure subscription (requires az login)
terraform plan
```

The CI pipeline (`terraform-module-ci.yml`) runs the first three steps automatically on every pull request and push that touches `modules/**` or `examples/**`.

---

## Versioning

This monorepo uses **repository-level semantic versioning**. A single Git tag applies to all modules at once.

| Tag | When to use |
|-----|-------------|
| `vX.Y.Z` patch | Bug fixes, documentation updates |
| `vX.Y.Z` minor | New features, new modules (backward-compatible) |
| `vX.Y.Z` major | Breaking changes to existing module interfaces |

**Creating a release:**

```bash
git tag v1.1.0 -m "Add Key Vault module"
git push origin v1.1.0
```

Pushing a tag matching `v*.*.*` automatically triggers `terraform-module-release.yml`, which creates a GitHub Release with auto-generated release notes.

Consumers upgrade by updating the `?ref=` value and running `terraform init -upgrade`.

---

## Contributing

1. Create a feature branch from `main`.
2. Add or update a module under `modules/` and a matching example under `examples/`.
3. Run local validation (`fmt`, `init -backend=false`, `validate`) before opening a PR.
4. Open a pull request — CI validates all modules and examples automatically.
5. After review and merge, cut a new tag to publish the release.
