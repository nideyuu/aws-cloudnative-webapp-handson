output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "public_subnet_1a_id" {
  description = "Public subnet ID in ap-northeast-1a."
  value       = aws_subnet.public_1a.id
}

output "public_subnet_1c_id" {
  description = "Public subnet ID in ap-northeast-1c."
  value       = aws_subnet.public_1c.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]
}

output "private_app_subnet_1a_id" {
  description = "Private app subnet ID in ap-northeast-1a."
  value       = aws_subnet.private_app_1a.id
}

output "private_app_subnet_1c_id" {
  description = "Private app subnet ID in ap-northeast-1c."
  value       = aws_subnet.private_app_1c.id
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs."
  value = [
    aws_subnet.private_app_1a.id,
    aws_subnet.private_app_1c.id
  ]
}

output "private_db_subnet_1a_id" {
  description = "Private DB subnet ID in ap-northeast-1a."
  value       = aws_subnet.private_db_1a.id
}

output "private_db_subnet_1c_id" {
  description = "Private DB subnet ID in ap-northeast-1c."
  value       = aws_subnet.private_db_1c.id
}

output "private_db_subnet_ids" {
  description = "Private DB subnet IDs."
  value = [
    aws_subnet.private_db_1a.id,
    aws_subnet.private_db_1c.id
  ]
}

output "internet_gateway_id" {
  description = "Internet Gateway ID."
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = aws_nat_gateway.main_1a.id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_app_route_table_id" {
  description = "Private app route table ID."
  value       = aws_route_table.private_app.id
}

output "private_db_route_table_id" {
  description = "Private DB route table ID."
  value       = aws_route_table.private_db.id
}
