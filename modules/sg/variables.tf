variable "tags" {
  description = "Tags to apply to all security groups"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID to associate the security groups with"
  type        = string
}

variable "security_groups" {
  description = "Basic security group definitions (name, description only)"
  type = list(object({
    name        = string
    description = string
  }))
}

variable "security_group_rules" {
  description = "Security group ingress/egress rules"
  type = list(object({
    name                  = string
    type                  = string
    from_port             = number
    to_port               = number
    protocol              = string
    security_group_name   = string
    source_sg_name        = optional(string)
    cidr_blocks           = optional(list(string))
  }))
}