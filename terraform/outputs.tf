output "aws_region" {
  description = "AWS region."
  value       = var.aws_region
}

output "project_name" {
  description = "Project name."
  value       = var.project_name
}

output "vpc_id" {
  description = "VPC ID."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs."
  value       = module.network.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Private DB subnet IDs."
  value       = module.network.private_db_subnet_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = module.network.nat_gateway_id
}
