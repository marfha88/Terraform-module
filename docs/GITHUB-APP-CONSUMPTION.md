# Consuming Modules via a GitHub App

If your organisation restricts cloning via HTTPS PAT tokens, you can use a
GitHub App to authenticate Terraform when it pulls modules.

## Overview

1. Create a GitHub App with **Contents: Read** permission on this repository.
2. Install the App on the repository.
3. Generate a private key for the App.
4. Exchange the private key for a short-lived installation token at plan/apply
   time and pass it to `git` via a credential helper.

## Credential Helper Setup

Add the following to your CI pipeline before running `terraform init`:

```bash
#!/usr/bin/env bash
# scripts/github-app-token.sh
APP_ID="<your-app-id>"
INSTALLATION_ID="<your-installation-id>"
PRIVATE_KEY_PATH="<path-to-private-key.pem>"

# Generate JWT
JWT=$(python3 scripts/generate_jwt.py "$APP_ID" "$PRIVATE_KEY_PATH")

# Exchange for installation token
TOKEN=$(curl -s -X POST \
  -H "Authorization: ******" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens" \
  | jq -r '.token')

git config --global url."https://x-access-token:${TOKEN}@github.com/".insteadOf \
  "https://github.com/"
```

## Terraform Source URL

Use the same HTTPS source URL — the credential helper handles authentication:

```hcl
module "resource_group" {
  source = "git::https://github.com/marfha88/Terraform-module.git//modules/terraform_azurerm_resource_group?ref=v1.0.0"
  # ...
}
```

## Security Considerations

* Store the App private key in a secrets manager (e.g., Azure Key Vault, GitHub Actions secrets).
* Rotate installation tokens — they expire after one hour.
* Use the principle of least privilege: grant **Contents: Read** only.
