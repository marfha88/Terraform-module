output "id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.sa.id
}

output "name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.sa.name
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint URL."
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The primary access key of the storage account."
  value       = azurerm_storage_account.sa.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string of the storage account."
  value       = azurerm_storage_account.sa.primary_connection_string
  sensitive   = true
}
