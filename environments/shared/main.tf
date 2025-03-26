module "vpc" {
  source = "../../modules/network/vpc"

  cidr_block = "10.0.0.0/16"
  name       = "shared-vpc"
}

module "subnet" {
  source = "../../modules/network/subnet"

  vpc_id = module.vpc.vpc_id
  name_prefix = "shared"

  public_subnet_cidrs = {
    "ap-northeast-2a" = "10.0.1.0/24"
  }

  web_private_subnet_cidrs = {}
  app_private_subnet_cidrs = {}
  db_private_subnet_cidrs = {}
}

module "route_table" {
  source = "../../modules/network/route-table"

  vpc_id = module.vpc.vpc_id
  name_prefix = "shared"
  internet_gateway_id = module.vpc.internet_gateway_id

  public_subnet_ids = {
    "ap-northeast-2a" = module.subnet.public_subnets[0]
  }

  nat_gateway_ids = {}
  private_subnet_group_az_map = {}
}

module "bastion_sg" {
  source = "../../modules/instance/security-group"

  name        = "bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["211.244.225.164/32"]
    }
  ]
}

module "bastion" {
  source = "../../modules/instance/ec2"

  name               = "bastion"
  ami_id             = "ami-062cddb9d94dcf95d"
  instance_type      = "t3.micro"
  subnet_id          = module.subnet.public_subnets[0]
  security_group_ids = [module.bastion_sg.security_group_id]
  key_name           = "KTB-personal-project-keypair"
}
