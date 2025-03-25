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

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
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

variable "user_data" {
  type = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}