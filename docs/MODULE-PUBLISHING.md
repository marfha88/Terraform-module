# Module Publishing Guide

This guide covers the process for adding new modules and releasing new versions.

## Adding a New Module

1. Create a folder under `modules/` using the naming convention
   `terraform_azurerm_<resource_type>`.
2. Create the required files:
   - `main.tf` — resources
   - `variables.tf` — input variables with descriptions and validations
   - `outputs.tf` — outputs (id, name, endpoints, principal ids)
   - `locals.tf` — computed names and derived values
   - `versions.tf` — `terraform` and `required_providers` blocks

3. Create a matching example under `examples/terraform_azurerm_<resource_type>/`:
   - `common.tf` — provider and terraform configuration
   - `example.tf` — module call
   - `variables.tf` — example-level variables
   - `outputs.tf` — surfaced outputs

4. Run local validation:
   ```bash
   terraform fmt -check -recursive
   cd modules/terraform_azurerm_<resource_type> && terraform init -backend=false && terraform validate
   cd examples/terraform_azurerm_<resource_type> && terraform init -backend=false && terraform validate
   ```

5. Open a pull request — CI validates fmt, init, and validate automatically.

## Releasing a New Version

1. Merge all changes to the default branch.
2. Determine the new version following [semver](https://semver.org/):
   - **Patch** (`vX.Y.Z+1`): bug fixes, no API changes.
   - **Minor** (`vX.Y+1.0`): new backwards-compatible features.
   - **Major** (`vX+1.0.0`): breaking changes.
3. Create and push a tag:
   ```bash
   git tag v1.2.3 -m "Release v1.2.3: <short description>"
   git push origin v1.2.3
   ```
4. The `terraform-module-release.yml` workflow creates a GitHub Release with
   auto-generated notes.
5. Update consumers to reference the new tag via `?ref=v1.2.3`.

## Breaking Change Policy

* Document breaking changes in the PR body under a `## Breaking Changes` heading.
* Bump the major version.
* Update example usage in this repo to reflect the new interface.
