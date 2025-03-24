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

module "sg" {
  source = "../../modules/sg"
  vpc_id = module.vpc.vpc_id
  tags = var.tags
  security_groups = var.security_groups
  security_group_rules = var.security_group_rules
}

module "ec2_web" {
  source = "../../modules/ec2"

  ami_id             = "ami-062cddb9d94dcf95d"
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.private_subnet_ids[0]
  security_group_id  = module.sg.security_group_ids["web-sg"]
  key_name           = var.key_name
  name               = "web"
  tags               = var.tags
}

module "ec2_app" {
  source = "../../modules/ec2"

  ami_id             = "ami-062cddb9d94dcf95d"
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.private_subnet_ids[1]
  security_group_id  = module.sg.security_group_ids["app-sg"]
  key_name           = var.key_name
  name               = "app"
  tags               = var.tags
}

resource "aws_lb" "web" {
  name               = "dev-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sg.security_group_ids["alb-sg"]]
  subnets            = module.vpc.public_subnet_ids
  tags               = var.tags
}

resource "aws_lb_target_group" "web" {
  name     = "dev-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = var.tags
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = module.ec2_web.instance_id
  port             = 80
}
