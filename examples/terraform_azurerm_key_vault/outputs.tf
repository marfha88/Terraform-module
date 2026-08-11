output "id" {
  description = "The ID of the Key Vault."
  value       = module.key_vault.id
}

output "name" {
  description = "The name of the Key Vault."
  value       = module.key_vault.name
}

output "vault_uri" {
  description = "The URI of the Key Vault."
  value       = module.key_vault.vault_uri
}
