# Module Publishing Guide

This guide explains how to author, validate, and publish a new Terraform module to this monorepo.

---

## 1. Creating a New Module

### Directory layout

```
modules/
└── <module-name>/
    ├── main.tf        # Resources
    ├── variables.tf   # Input variables
    ├── outputs.tf     # Output values
    ├── versions.tf    # Required providers and Terraform version constraint
    └── README.md      # Module documentation
```

### Matching example

Every module **must** have a runnable example under `examples/` with an identical folder name:

```
examples/
└── <module-name>/
    ├── main.tf        # Calls the module with representative values
    └── README.md      # How to run the example
```

---

## 2. Module Authoring Standards

### Required files

| File | Purpose |
|------|---------|
| `main.tf` | All resource definitions |
| `variables.tf` | Every input must have a `description`; sensitive inputs must set `sensitive = true` |
| `outputs.tf` | Expose useful resource attributes for downstream consumers |
| `versions.tf` | Pin the minimum Terraform version and required provider versions |
| `README.md` | Usage example, input/output table, notes |

### Code style

- Run `terraform fmt -recursive` before committing — the CI pipeline enforces this.
- Use `snake_case` for all resource labels, variable names, and output names.
- Do not hard-code region, subscription ID, or tenant ID — accept them as variables.
- Always include a `tags` variable of type `map(string)` and propagate it to every resource that supports tags.

### Versioning constraints

```hcl
# versions.tf
terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0, < 5.0"
    }
  }
}
```

---

## 3. Local Validation

Run these commands from within the module directory before opening a pull request:

```bash
cd modules/<module-name>

# 1. Format check (must pass — CI enforces this)
terraform fmt -check -recursive

# 2. Initialise without remote backend
terraform init -backend=false

# 3. Validate syntax and internal references
terraform validate

# 4. (Recommended) Plan against a real subscription
terraform plan
```

Repeat the same steps for the matching example:

```bash
cd examples/<module-name>
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

---

## 4. Pull Request Process

1. Branch off `main` using a descriptive name, e.g., `feat/add-vnet-module`.
2. Add or update module files and the matching example.
3. Run local validation (step 3 above).
4. Open a pull request — CI will automatically validate all modules and examples.
5. At least one peer review is required before merging.
6. Merge using **Squash and merge** to keep `main` history linear.

---

## 5. Releasing a New Version

After merging to `main`, create and push a semver tag to trigger the release workflow:

```bash
git checkout main
git pull origin main

# Bump the version according to the change type:
# PATCH — bug fixes, docs
# MINOR — new modules, new optional inputs
# MAJOR — breaking changes to existing interfaces
git tag v1.2.3
git push origin v1.2.3
```

The release workflow (`.github/workflows/release.yml`) will:
1. Detect the new tag.
2. Create a GitHub Release with auto-generated release notes from merged PR titles.

Consumers can then reference the new version with `?ref=v1.2.3`.

---

## 6. Deprecating or Removing a Module

1. Add a deprecation notice to the module's `README.md`.
2. Open a PR and announce the deprecation in the PR description.
3. Allow at least one **MINOR** version after the deprecation notice before removal.
4. Remove the module directory in a subsequent **MAJOR** version bump.
