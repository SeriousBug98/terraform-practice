module "vpc" {
  source = "../../modules/vpc"
  name               = var.name
  cidr_block         = var.cidr_block
  azs                = var.azs
  tags               = var.tags
  create_igw         = var.create_igw
  create_nat_gw      = var.create_nat_gw
  nat_gateway_count  = var.nat_gateway_count
  subnets            = var.subnets
}