name        = "dev-vpc"
cidr_block  = "10.1.0.0/16"
azs         = ["ap-northeast-2a", "ap-northeast-2c"]

create_igw        = true
create_nat_gw     = true
nat_gateway_count = 2

tags = {
  Environment = "dev"
  Project     = "KTB-personal-project"
}

subnets = [
  { az = "ap-northeast-2a", cidr = "10.1.1.0/24", type = "public" },
  { az = "ap-northeast-2c", cidr = "10.1.2.0/24", type = "public" },
  { az = "ap-northeast-2a", cidr = "10.1.3.0/24", type = "web" },
  { az = "ap-northeast-2c", cidr = "10.1.4.0/24", type = "web" },
  { az = "ap-northeast-2a", cidr = "10.1.5.0/24", type = "app" },
  { az = "ap-northeast-2c", cidr = "10.1.6.0/24", type = "app" },
  { az = "ap-northeast-2a", cidr = "10.1.7.0/24", type = "db" },
  { az = "ap-northeast-2c", cidr = "10.1.8.0/24", type = "db" }
]