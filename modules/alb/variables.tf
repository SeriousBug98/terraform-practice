variable "name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "load_balancer_type" {
  type = string
}

variable "port" {
  type = number
}

variable "protocol" {
  type = string
  default = "HTTP"
}

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "target_type" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
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
