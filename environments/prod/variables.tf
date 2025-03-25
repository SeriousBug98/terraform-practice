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

# EC2 or ASG variables
variable "key_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "web_user_data" {
  type = string
}

variable "app_user_data" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "web_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "web_internal" {
  type = bool
}

variable "app_internal" {
  type = bool
}

variable "web_port" {
  type = number
}

variable "app_port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "target_type" {
  type = string
}

variable "health_check" {
  type = object({
    path                = string
    protocol            = string
    matcher             = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}