variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type        = string
  description = "Base64 encoded user data for launch template"
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs"
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of ALB Target Group ARNs"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 1
}
