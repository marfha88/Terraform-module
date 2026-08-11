# Module Consumption Guide

This guide explains how to consume Terraform modules from this repository in your own Terraform configurations.

---

## Prerequisites

- Terraform ≥ 1.3
- Access to the `marfha88/Terraform-module` GitHub repository
- (Optional) A GitHub Personal Access Token or GitHub App credentials if the repository is private

---

## Referencing a Module via Git Source

Use the native Terraform `git::` source type with a `?ref=` query parameter to pin to a specific release tag.

```hcl
module "<logical_name>" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/<module-name>?ref=v<X.Y.Z>"

  # Module inputs
  ...
}
```

### Example — Resource Group module at v1.0.0

```hcl
module "core_resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/resource-group?ref=v1.0.0"

  name     = "core-rg"
  location = "westeurope"
  tags = {
    environment = "production"
    team        = "platform"
  }
}
```

### Key URL components

| Part | Description |
|------|-------------|
| `git::https://github.com/...` | Forces the git fetcher |
| `//modules/<name>` | Double-slash separates the repo root from the subdirectory |
| `?ref=vX.Y.Z` | Pinned semver tag — **always required in production** |

---

## Authentication for Private Repositories

### HTTPS with a token

Set the `GIT_ASKPASS` or configure Git credentials before running `terraform init`:

```bash
export GIT_ASKPASS=/usr/lib/git-core/git-askpass
git config --global url."https://<TOKEN>@github.com/".insteadOf "https://github.com/"
```

### SSH

```hcl
source = "git::ssh://git@github.com/marfha88/Terraform-module.git//modules/<module-name>?ref=v1.0.0"
```

Ensure the SSH key is available to the process running Terraform.

---

## Upgrading a Module

1. Review the [CHANGELOG](../CHANGELOG.md) or GitHub Release notes for the target version.
2. Update the `?ref=` value in your `source` attribute.
3. Run `terraform init -upgrade` to fetch the new source.
4. Run `terraform plan` and review the diff before applying.

---

## Locking Module Versions

After running `terraform init`, Terraform records the downloaded module in `.terraform.lock.hcl` (for providers) and `.terraform/modules/` (for modules). Commit `.terraform.lock.hcl` to source control, but **do not commit** `.terraform/modules/`.

```gitignore
# .gitignore
.terraform/
!.terraform.lock.hcl
```

---

## Best Practices

- Always pin to a semver tag — never use `?ref=main` or omit the ref in production.
- Review the module's `README.md` for required and optional variables before consuming.
- Use `terraform validate` and `terraform plan` in CI before applying changes.
