module "vpc" {
  source     = "../../modules/network/vpc"

  cidr_block = "10.1.0.0/16"
  name       = "dev-vpc"
}

module "subnet" {
  source      = "../../modules/network/subnet"

  vpc_id      = module.vpc.vpc_id
  name_prefix = "dev"

  public_subnet_cidrs = {
    "ap-northeast-2a" = "10.1.1.0/24"
    "ap-northeast-2c" = "10.1.2.0/24"
  }
  web_private_subnet_cidrs = {
    "ap-northeast-2a" = "10.1.3.0/24"
    "ap-northeast-2c" = "10.1.4.0/24" 
  }
  app_private_subnet_cidrs = {
    "ap-northeast-2a" = "10.1.5.0/24"
    "ap-northeast-2c" = "10.1.6.0/24"
  }
  db_private_subnet_cidrs = {
    "ap-northeast-2a" = "10.1.7.0/24"
    "ap-northeast-2c" = "10.1.8.0/24" 
  }
}

module "nat_gateway" {
  source = "../../modules/network/nat-gateway"

  name_prefix = "dev"

  public_subnet_ids = {
    "ap-northeast-2a" = module.subnet.public_subnets[0]
    "ap-northeast-2c" = module.subnet.public_subnets[1]
  }
}

module "route_table" {
  source = "../../modules/network/route-table"

  vpc_id = module.vpc.vpc_id
  name_prefix = "dev"

  internet_gateway_id = module.vpc.internet_gateway_id
  public_subnet_ids = {
    "ap-northeast-2a" = module.subnet.public_subnets[0]
    "ap-northeast-2c" = module.subnet.public_subnets[1]
  }

  nat_gateway_ids = module.nat_gateway.nat_gateway_ids
  private_subnet_group_az_map = {
    "ap-northeast-2a" = [
      module.subnet.web_private_subnets[0],
      module.subnet.app_private_subnets[0],
      module.subnet.db_private_subnets[0]
    ]
    "ap-northeast-2c" = [
      module.subnet.web_private_subnets[1],
      module.subnet.app_private_subnets[1],
      module.subnet.db_private_subnets[1]
    ]
  }
}

output "public_route_table_id" {
  value = module.route_table.public_route_table_ids
}

module "web_alb_sg" {
  source = "../../modules/network/security-group"

  name   = "web-alb-sg"
  description = "Security group for web ALB"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

module "web_instance_sg" {
  source = "../../modules/network/security-group"

  name   = "web-ec2-sg"
  description = "Security group for web instance"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [module.web_alb_sg.security_group_id]
    }
  ]
}

module "app_alb_sg" {
  source = "../../modules/network/security-group"

  name   = "app-alb-sg"
  description = "Security group for app ALB"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTP from inside VPC"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"] # 내부 VPC 통신용 (또는 web EC2 SG 등으로 좁혀도 됨)
    }
  ]
}

module "app_instance_sg" {
  source = "../../modules/network/security-group"

  name   = "app-ec2-sg"
  description = "Security group for app instance"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      description     = "Allow from app ALB"
      from_port       = 8080
      to_port         = 8080
      protocol        = "tcp"
      security_groups = [module.app_alb_sg.security_group_id]
    }
  ]
}

module "web_asg" {
  source = "../../modules/instance/asg"

  name                = "web"
  ami_id              = "ami-062cddb9d94dcf95d"
  instance_type       = "t3.micro"
  key_name            = "KTB-personal-project-keypair"
  user_data           = file("${path.module}/scripts/web-userdata.sh")
  security_group_ids  = [module.web_instance_sg.security_group_id]
  subnet_ids          = module.subnet.web_private_subnets
  target_group_arns   = [module.web_alb.target_group_arn]
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
}

module "app_asg" {
  source = "../../modules/instance/asg"

  name                = "app"
  ami_id              = "ami-062cddb9d94dcf95d"
  instance_type       = "t3.micro"
  key_name            = "KTB-personal-project-keypair"
  user_data           = file("${path.module}/scripts/app-userdata.sh")
  security_group_ids  = [module.app_instance_sg.security_group_id]
  subnet_ids          = module.subnet.app_private_subnets
  target_group_arns   = [module.app_alb.target_group_arn]
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
}

module "web_alb" {
  source = "../../modules/instance/alb"

  name               = "web-alb"
  internal           = false
  subnet_ids         = module.subnet.public_subnets
  security_group_ids = [module.web_alb_sg.security_group_id]
  vpc_id             = module.vpc.vpc_id
  target_port        = 80
  health_check_path  = "/"
}

module "app_alb" {
  source = "../../modules/instance/alb"

  name               = "app-alb"
  internal           = true
  subnet_ids         = module.subnet.app_private_subnets
  security_group_ids = [module.app_alb_sg.security_group_id]
  vpc_id             = module.vpc.vpc_id
  target_port        = 8080
  health_check_path  = "/health"
}
