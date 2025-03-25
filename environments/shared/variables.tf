# 공통 variables
variable "tags" {
  type = map(string)
}

# VPC variables
variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "create_igw" {
  type = bool
}

variable "create_nat_gw" {
  type = bool
}

variable "nat_gateway_count" {
  type = number
}

variable "subnets" {
  type = list(object({
    az   = string
    cidr = string
    type = string
  }))
}

# SG variables
variable "security_groups" {
  type = any
}

variable "security_group_rules" {
  type = any
}

# EC2 variables
variable "key_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ec2_name" {
  type = string
}