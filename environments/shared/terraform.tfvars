# 공통
tags = {
  Environment = "shared"
  Project     = "KTB-personal-project"
}

# VPC
vpc_name        = "shared-vpc"
cidr_block  = "10.0.0.0/16"
azs         = ["ap-northeast-2a"]

create_igw        = true
create_nat_gw     = false
nat_gateway_count = 0

subnets = [
  { az = "ap-northeast-2a", cidr = "10.0.1.0/24", type = "public" }
]

# SG
security_groups = [
  { name = "bastion-sg",        description = "Allow SSH from Developer" }
]

security_group_rules = [
  {
    name                  = "bastion-from-developer"
    type                  = "ingress"
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    security_group_name   = "bastion-sg"
    cidr_blocks           = ["211.244.225.164/32"]
  }
]

# EC2
key_name = "KTB-personal-project-keypair"

ami_id = "ami-062cddb9d94dcf95d"

instance_type = "t3.micro"

ec2_name = "bastion"