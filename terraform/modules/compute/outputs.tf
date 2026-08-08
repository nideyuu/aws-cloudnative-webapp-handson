output "app_instance_id" {
  description = "Application EC2 instance ID."
  value       = aws_instance.app.id
}

output "app_private_ip" {
  description = "Application EC2 private IP address."
  value       = aws_instance.app.private_ip
}
