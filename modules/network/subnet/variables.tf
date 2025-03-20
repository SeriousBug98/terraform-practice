variable "vpc_id" {}
variable "public_subnets" {
  description = "List of public subnets with CIDR and availability zones"
  type = list(object({
    cidr = string
    az = string
  }))
}
variable "private_subnets" {
  description = "List of private subnets with CIDR and availability zones"
  type        = list(object({
    cidr = string
    az   = string
  }))
}
variable "environment" {}