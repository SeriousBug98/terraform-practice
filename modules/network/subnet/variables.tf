variable "vpc_id" {
  type        = string
  description = "VPC ID to attach the subnets to"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for naming the subnets"
}

variable "public_subnet_cidrs" {
  type = map(string)
  description = "Map of AZ to CIDR for public subnets"
}

variable "web_private_subnet_cidrs" {
  type = map(string)
  description = "Map of AZ to CIDR for web private subnets"
}

variable "app_private_subnet_cidrs" {
  type = map(string)
  description = "Map of AZ to CIDR for app private subnets"
}

variable "db_private_subnet_cidrs" {
  type = map(string)
  description = "Map of AZ to CIDR for db private subnets"
}
