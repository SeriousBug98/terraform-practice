variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups = optional(list(string)) # SG 간 허용도 가능
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    description     = optional(string)
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    security_groups = optional(list(string))
  }))
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}
