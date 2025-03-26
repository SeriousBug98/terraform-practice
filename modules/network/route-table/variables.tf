variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type = string

}

variable "internet_gateway_id" {
  type        = string
  description = "ID of the Internet Gateway"
}

variable "public_subnet_ids" {
  type        = map(string)
  description = "List of public subnet IDs to associate with public route table"
}

variable "nat_gateway_ids" {
  type = map(string)
  description = "AZ 이름을 key로 하는 NAT Gateway ID"
}

variable "private_subnet_group_az_map" {
  type = map(list(string))
  description = "AZ 별 private subnet 목록"
}
