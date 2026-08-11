output "id" {
  description = "The ID of the storage account."
  value       = module.storage_account.id
}

output "name" {
  description = "The name of the storage account."
  value       = module.storage_account.name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint URL."
  value       = module.storage_account.primary_blob_endpoint
}
