name        = "shared-vpc"
cidr_block  = "10.0.0.0/16"
azs         = ["ap-northeast-2a"]

create_igw        = true
create_nat_gw     = false
nat_gateway_count = 0

tags = {
  Environment = "shared"
  Project     = "KTB-personal-project"
}

subnets = [
  { az = "ap-northeast-2a", cidr = "10.0.1.0/24", type = "public" }
]