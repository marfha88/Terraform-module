# Terraform Module Monorepo

A public example repository demonstrating how to author and publish reusable Azure Terraform modules. This repo serves as both a learning resource and a working module registry consumed via Git source references.

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── terraform-module-ci.yml      # Validate modules and examples on PR/push
│       └── terraform-module-release.yml # Create GitHub Release on semver tag
├── docs/
│   ├── MODULE-CONSUMPTION.md            # How to consume modules from Git
│   ├── MODULE-PUBLISHING.md             # How to author and publish modules
│   └── GITHUB-APP-CONSUMPTION.md       # Consuming via a GitHub App token
├── modules/
│   ├── terraform_azurerm_resource_group/
│   ├── terraform_azurerm_storage_account/
│   └── terraform_azurerm_key_vault/
└── examples/
    ├── terraform_azurerm_resource_group/
    ├── terraform_azurerm_storage_account/
    └── terraform_azurerm_key_vault/
```

## Consuming a Module

Reference any module by pointing at this repo with a `?ref=vX.Y.Z` Git tag:

```hcl
module "resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_resource_group?ref=v1.0.0"

  name     = "myapp-prod-rg"
  location = "westeurope"
  tags     = { environment = "prod" }
}
```

See [docs/MODULE-CONSUMPTION.md](docs/MODULE-CONSUMPTION.md) for the full guide.

## Module Authoring Rules

- Each module lives under `modules/<module_name>/`.
- Required files per module: `main.tf`, `variables.tf`, `outputs.tf`, `locals.tf`, `versions.tf`.
- Terraform `>= 1.6` and `azurerm ~> 3.0` are required.
- Provider configuration belongs in **examples only** — never inside a module.
- Add `validation` blocks on all critical input variables.
- Expose only practical outputs (`id`, `name`, endpoint URLs, sensitive values marked `sensitive = true`).
- No hardcoded secrets or tenant IDs.
- Run `terraform fmt -recursive` before committing.

## Local Validation

```bash
# Format check
terraform fmt -check -recursive

# Initialise without a backend
terraform init -backend=false

# Validate configuration
terraform validate

# Plan against a real subscription (optional)
terraform plan
```

## Versioning Strategy

This monorepo uses **repository-level semver tags**. Every tag applies to all modules simultaneously.

| Tag       | Meaning                          |
|-----------|----------------------------------|
| `v1.0.0`  | Initial stable release           |
| `v1.1.0`  | Backward-compatible new features |
| `v1.1.1`  | Bug fixes                        |
| `v2.0.0`  | Breaking changes                 |

Create a new release:

```bash
git tag v1.1.0
git push origin v1.1.0
```

The `terraform-module-release.yml` workflow automatically creates a GitHub Release with generated release notes.
