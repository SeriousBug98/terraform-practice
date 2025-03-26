variable "name_prefix" {
  type = string
}

variable "public_subnet_ids" {
  type = map(string)
  description = "AZ 이름을 key로 하는 퍼블릭 서브넷 ID"
}
