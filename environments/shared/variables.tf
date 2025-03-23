variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "tags" {
  type = map(string)
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