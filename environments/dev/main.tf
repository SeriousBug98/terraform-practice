module "vpc" {
  source = "../../modules/vpc"
  name               = var.vpc_name
  cidr_block         = var.cidr_block
  azs                = var.azs
  tags               = var.tags
  create_igw         = var.create_igw
  create_nat_gw      = var.create_nat_gw
  nat_gateway_count  = var.nat_gateway_count
  subnets            = var.subnets
}

module "sg" {
  source = "../../modules/sg"
  vpc_id = module.vpc.vpc_id
  tags = var.tags
  security_groups = var.security_groups
  security_group_rules = var.security_group_rules
}

## 단일 인스턴스 생성할 때 사용

# module "ec2_web" {
#   source = "../../modules/ec2"
#   ami_id             = var.ami_id
#   instance_type      = var.instance_type
#   subnet_id          = module.vpc.private_subnet_ids[0]
#   security_group_id  = module.sg.security_group_ids["web-sg"]
#   key_name           = var.key_name
#   ec2_name           = var.web_ec2_name
#   tags               = var.tags
# }

# module "ec2_app" {
#   source = "../../modules/ec2"

#   ami_id             = var.ami_id
#   instance_type      = var.instance_type
#   subnet_id          = module.vpc.private_subnet_ids[1]
#   security_group_id  = module.sg.security_group_ids["app-sg"]
#   key_name           = var.key_name
#   ec2_name           = var.app_ec2_name
#   tags               = var.tags
# }

module "alb_web" {
  source              = "../../modules/alb"
  name                = var.web_name
  internal            = var.web_internal
  load_balancer_type  = var.load_balancer_type
  port                = var.web_port
  protocol            = var.protocol
  security_group_id   = module.sg.security_group_ids["alb-sg"]
  subnet_ids          = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  target_type         = var.target_type
  health_check        = var.health_check
  tags                = var.tags
}

module "alb_app" {
  source              = "../../modules/alb"
  name                = var.app_name
  internal            = var.app_internal
  load_balancer_type  = var.load_balancer_type
  port                = var.app_port
  protocol            = var.protocol
  security_group_id   = module.sg.security_group_ids["alb-app-sg"]
  subnet_ids          = module.vpc.app_subnet_ids
  vpc_id              = module.vpc.vpc_id
  target_type         = var.target_type
  health_check        = var.health_check
  tags                = var.tags
}

module "asg_web" {
  source             = "../../modules/asg"
  name               = var.web_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_id  = module.sg.security_group_ids["web-sg"]
  subnet_ids         = module.vpc.private_subnet_ids
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
  user_data          = var.web_user_data
  target_group_arns  = [module.alb_web.target_group_arn]
  tags               = var.tags
}

module "asg_app" {
  source             = "../../modules/asg"
  name               = var.app_name
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_id  = module.sg.security_group_ids["app-sg"]
  subnet_ids         = module.vpc.private_subnet_ids
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
  user_data          = var.app_user_data
  target_group_arns  = [module.alb_app.target_group_arn]
  tags               = var.tags
}
