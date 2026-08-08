variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs for EC2 instances."
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "Security Group ID for EC2."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}
