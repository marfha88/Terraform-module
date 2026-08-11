output "resource_group_id" {
  description = "Resource ID of the created resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the created resource group."
  value       = module.resource_group.name
}
