module "vpc" {
  source = "../../modules/network/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name = "dev-vpc"
  environment = "dev"
}