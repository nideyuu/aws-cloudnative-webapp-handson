variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "cloudnative-webapp"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for the public subnet in ap-northeast-1a."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_1c_cidr" {
  description = "CIDR block for the public subnet in ap-northeast-1c."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_app_subnet_1a_cidr" {
  description = "CIDR block for the private app subnet in ap-northeast-1a."
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_app_subnet_1c_cidr" {
  description = "CIDR block for the private app subnet in ap-northeast-1c."
  type        = string
  default     = "10.0.12.0/24"
}

variable "private_db_subnet_1a_cidr" {
  description = "CIDR block for the private DB subnet in ap-northeast-1a."
  type        = string
  default     = "10.0.21.0/24"
}

variable "private_db_subnet_1c_cidr" {
  description = "CIDR block for the private DB subnet in ap-northeast-1c."
  type        = string
  default     = "10.0.22.0/24"
}
