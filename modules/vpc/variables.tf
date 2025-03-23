variable "name" {
  description = "VPC 이름"
  type        = string
}

variable "cidr_block" {
  description = "VPC의 CIDR 블록"
  type        = string
}

variable "azs" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}

variable "create_igw" {
  description = "인터넷 게이트웨이 생성 여부"
  type        = bool
  default     = true
}

variable "create_nat_gw" {
  description = "NAT Gateway 생성 여부"
  type        = bool
  default     = false
}

variable "nat_gateway_count" {
  description = "NAT Gateway 수"
  type        = number
  default     = 0
}

variable "public_subnet_ids" {
  description = "NAT Gateway를 배치할 퍼블릭 서브넷 ID 목록"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "생성할 서브넷 정보 리스트"
  type = list(object({
    az   = string
    cidr = string
    type = string  # public, web, app, db 등
  }))
}