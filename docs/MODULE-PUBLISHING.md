# Module Publishing Guide

This guide explains how to author a new module and publish a release.

## Authoring a New Module

1. Create a new folder under `modules/` following the naming convention `terraform_azurerm_<resource>`.
2. Add the required files:

   | File | Purpose |
   |------|---------|
   | `variables.tf` | Input variable declarations with validation |
   | `locals.tf` | Computed/derived values |
   | `main.tf` | Resource declarations |
   | `outputs.tf` | Output declarations |

3. Create a matching example under `examples/terraform_azurerm_<resource>/` with:
   - `common.tf` — provider configuration
   - `example.tf` — module call
   - `variables.tf` — example variables with sensible defaults
   - `outputs.tf` — example outputs

## Module Standards

- Set `required_version = ">= 1.6"` and `azurerm ~> 3.0` in `versions.tf`.
- Add `validation` blocks on critical variables (names, enums, numeric ranges).
- Mark sensitive outputs (`sensitive = true`).
- Do **not** configure the `azurerm` provider inside a module.
- Run `terraform fmt -recursive` before committing.

## Publishing a Release

1. Merge your changes to the default branch.
2. Create and push a semver tag:

   ```bash
   git tag v1.1.0 -m "Add new module"
   git push origin v1.1.0
   ```

3. The `terraform-module-release.yml` CI workflow automatically creates a GitHub Release with auto-generated notes.

## CI Validation

Every PR that touches `modules/**` or `examples/**` runs the `terraform-module-ci.yml` workflow which performs:

- `terraform fmt -check -recursive` — format validation
- `terraform init -backend=false` — provider initialisation
- `terraform validate` — configuration validation
