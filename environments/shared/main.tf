module "vpc" {
  source              = "../../modules/vpc"
  name                = var.name
  cidr_block          = var.cidr_block
  azs                 = var.azs
  tags                = var.tags
  create_igw          = var.create_igw
  create_nat_gw       = var.create_nat_gw
  nat_gateway_count   = var.nat_gateway_count
  subnets             = var.subnets
}

module "sg" {
  source = "../../modules/sg"
  vpc_id = module.vpc.vpc_id
  tags = var.tags
  security_groups = var.security_groups
  security_group_rules = var.security_group_rules
}

module "ec2_bastion" {
  source = "../../modules/ec2"

  ami_id             = "ami-062cddb9d94dcf95d"
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_id  = module.sg.security_group_ids["bastion-sg"]
  key_name           = "KTB-personal-project-keypair"
  name               = "bastion"
  tags               = {
    Environment = "shared"
    Project     = "KTB-personal-project"
  }
}
