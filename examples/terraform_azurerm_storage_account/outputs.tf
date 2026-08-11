output "storage_account_id" {
  description = "Resource ID of the storage account."
  value       = module.storage_account.id
}

output "storage_account_name" {
  description = "Name of the storage account."
  value       = module.storage_account.name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint."
  value       = module.storage_account.primary_blob_endpoint
}
