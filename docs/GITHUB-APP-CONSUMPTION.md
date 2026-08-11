# GitHub App Consumption Guide

This guide explains how to consume modules from this repository when your CI/CD pipeline authenticates via a **GitHub App** rather than a personal access token or SSH key.

---

## Why Use a GitHub App?

- GitHub Apps use short-lived installation tokens (1 hour TTL) — more secure than long-lived PATs.
- Fine-grained permissions: grant read access to only the repositories that contain modules.
- Auditable: all API calls are attributed to the App installation.

---

## Prerequisites

1. A GitHub App installed on the `marfha88` organisation with **Contents: Read** permission on `Terraform-module`.
2. The App's **App ID** and a **private key** (`.pem` file) stored as secrets in your consuming repository.

---

## Generating an Installation Token at Runtime

Use the `tibdex/github-app-token` GitHub Action (or equivalent) to exchange the App credentials for a short-lived token, then configure Git to use it before Terraform runs.

### GitHub Actions example

```yaml
jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Generate GitHub App token
        id: app-token
        uses: tibdex/github-app-token@v2
        with:
          app_id: ${{ secrets.MODULE_REPO_APP_ID }}
          private_key: ${{ secrets.MODULE_REPO_APP_PRIVATE_KEY }}

      - name: Configure Git to use App token
        run: |
          git config --global \
            url."https://x-access-token:${{ steps.app-token.outputs.token }}@github.com/".insteadOf \
            "https://github.com/"

      - name: Checkout consuming repo
        uses: actions/checkout@v4

      - name: Terraform Init
        run: terraform init
        working-directory: ./infra
```

Because the `git config` substitution is in place before `terraform init`, Terraform can clone the module source transparently.

---

## Terraform Module Source (no change needed)

Your `source` attribute remains the standard HTTPS URL with a pinned tag:

```hcl
module "resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/resource-group?ref=v1.0.0"
  ...
}
```

The Git credential substitution handles authentication automatically.

---

## Azure Pipelines / Other CI

Generate the token using a script that calls the GitHub Apps API:

```bash
# Generate a JWT, exchange it for an installation token, then:
git config --global \
  url."https://x-access-token:${INSTALLATION_TOKEN}@github.com/".insteadOf \
  "https://github.com/"
```

Libraries exist for most languages (e.g., `PyGithub`, `octokit`).

---

## Security Considerations

- Store the App private key as an **encrypted secret** — never commit it to source control.
- Scope the App's repository access to the minimum required.
- Rotate the private key periodically in accordance with your organisation's security policy.
- Installation tokens expire after 1 hour; they are not reusable across pipeline runs.
