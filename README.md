# Azure Terraform Module Monorepo

Central platform repository for reusable Azure Terraform modules.

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── terraform-module-ci.yml      # CI: fmt, init, validate on PR/push
│       └── terraform-module-release.yml # Release: GitHub Release on semver tag
├── docs/
│   ├── MODULE-CONSUMPTION.md
│   ├── GITHUB-APP-CONSUMPTION.md
│   └── MODULE-PUBLISHING.md
├── modules/
│   ├── terraform_azurerm_resource_group/
│   ├── terraform_azurerm_storage_account/
│   └── terraform_azurerm_key_vault/
└── examples/
    ├── terraform_azurerm_resource_group/
    ├── terraform_azurerm_storage_account/
    └── terraform_azurerm_key_vault/
```

Each module lives under `modules/<module_name>` and has a matching runnable example
under `examples/<module_name>`.

---

## Consuming a Module

Reference a module using the Git source with a pinned semver tag:

```hcl
module "resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_resource_group?ref=v1.0.0"

  name     = "my-rg"
  location = "eastus"
  tags     = { environment = "prod" }
}
```

See [docs/MODULE-CONSUMPTION.md](docs/MODULE-CONSUMPTION.md) for full guidance.

---

## Module Authoring Rules

1. **One module per folder** under `modules/`.
2. **Required files**: `main.tf`, `variables.tf`, `outputs.tf`, `locals.tf`, `versions.tf`.
3. **Provider configuration** belongs in examples only, never inside a module.
4. **No hardcoded secrets, tenant IDs, or subscription IDs.**
5. **Validate all critical inputs** with `variable` validation blocks.
6. **Use deterministic naming** via `locals` (e.g., `local.name`).
7. **Expose practical outputs only**: `id`, `name`, principal IDs, endpoints.
8. **Terraform >= 1.6** required.

---

## Local Validation Commands

Run these from within a module or example directory:

```bash
# Format check
terraform fmt -check -recursive

# Initialise without a backend
terraform init -backend=false

# Validate configuration
terraform validate

# Plan (examples only — supply variable values as needed)
terraform plan -var-file=example.tfvars
```

---

## Monorepo Versioning Strategy

This repo uses **monorepo semver tagging**. A single tag covers the entire
repository snapshot.

| Tag pattern | Meaning |
|---|---|
| `v1.0.0` | Stable release — safe for production |
| `v1.1.0` | Backwards-compatible new features |
| `v2.0.0` | Breaking change in one or more modules |

### Tagging guidance

```bash
# Create and push a release tag
git tag v1.2.3 -m "Release v1.2.3"
git push origin v1.2.3
```

Pushing a tag matching `v*.*.*` triggers the release workflow which
automatically creates a GitHub Release with generated release notes.

See [docs/MODULE-PUBLISHING.md](docs/MODULE-PUBLISHING.md) for full publishing guidance.
