variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for the public subnet in ap-northeast-1a."
  type        = string
}

variable "public_subnet_1c_cidr" {
  description = "CIDR block for the public subnet in ap-northeast-1c."
  type        = string
}

variable "private_app_subnet_1a_cidr" {
  description = "CIDR block for the private app subnet in ap-northeast-1a."
  type        = string
}

variable "private_app_subnet_1c_cidr" {
  description = "CIDR block for the private app subnet in ap-northeast-1c."
  type        = string
}

variable "private_db_subnet_1a_cidr" {
  description = "CIDR block for the private DB subnet in ap-northeast-1a."
  type        = string
}

variable "private_db_subnet_1c_cidr" {
  description = "CIDR block for the private DB subnet in ap-northeast-1c."
  type        = string
}
