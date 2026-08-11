# Azure Terraform Module Monorepo

Central platform module repository for reusable Azure Terraform modules.

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── terraform-module-ci.yml   # CI: fmt, init, validate for every module & example
│       └── release.yml               # Release: creates a GitHub release on semver tag push
├── docs/
│   ├── MODULE-CONSUMPTION.md         # How to consume modules via git source
│   ├── GITHUB-APP-CONSUMPTION.md     # Consuming modules through a GitHub App
│   └── MODULE-PUBLISHING.md          # How to author, version, and publish modules
├── modules/
│   └── <module-name>/                # One folder per reusable module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
└── examples/
    └── <module-name>/                # Runnable example matching the module folder name
        ├── main.tf
        └── README.md
```

---

## Consuming a Module from Git Source

Reference a specific version using the `?ref=` query parameter:

```hcl
module "my_resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/resource-group?ref=v1.2.3"

  name     = "my-rg"
  location = "eastus"
}
```

> **Always pin to a semver tag** (`?ref=vX.Y.Z`). Never use `?ref=main` in production.

See [docs/MODULE-CONSUMPTION.md](docs/MODULE-CONSUMPTION.md) for full guidance.

---

## Module Authoring Rules

1. **One module per folder** under `modules/`.
2. **Every module must have a matching example** under `examples/` with the same folder name.
3. Each module must contain at minimum: `main.tf`, `variables.tf`, `outputs.tf`, and a `README.md`.
4. All variables must have descriptions; sensitive variables must be marked `sensitive = true`.
5. Resources must use consistent naming conventions and support tagging via a `tags` variable.
6. Do not hard-code region or subscription — accept them as variables.
7. Run local validation (see below) before opening a pull request.

---

## Local Validation Commands

Run these from inside the module directory (e.g., `modules/resource-group/`):

```bash
# Format check
terraform fmt -check -recursive

# Initialise without a backend (no remote state required)
terraform init -backend=false

# Validate configuration syntax and internal consistency
terraform validate

# Optional: plan against a real subscription to catch provider errors
terraform plan
```

> The CI pipeline runs `fmt`, `init`, and `validate` automatically on every PR and push.

---

## Monorepo Semantic Versioning & Tagging Strategy

This repository uses a **single semver tag** that versions the entire monorepo (not individual modules).

### Version format

```
vMAJOR.MINOR.PATCH
```

| Increment | When to bump |
|-----------|-------------|
| **PATCH** | Bug fixes, documentation updates, non-breaking changes |
| **MINOR** | New modules or new optional variables (backward-compatible) |
| **MAJOR** | Breaking changes to existing module interfaces |

### Tagging workflow

```bash
# After merging to main, tag the commit:
git tag v1.2.3
git push origin v1.2.3
```

Pushing a tag matching `v*.*.*` triggers the **release workflow**, which creates a GitHub Release automatically.

### Changelogs

Document all changes in the GitHub Release notes (auto-generated from PR titles and commit messages).

---

## Further Reading

- [Module Consumption Guide](docs/MODULE-CONSUMPTION.md)
- [GitHub App Consumption Guide](docs/GITHUB-APP-CONSUMPTION.md)
- [Module Publishing Guide](docs/MODULE-PUBLISHING.md)
