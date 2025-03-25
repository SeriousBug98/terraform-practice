# 공통
tags = {
  Environment = "dev"
  Project     = "KTB-personal-project"
}

# VPC
vpc_name        = "dev-vpc"
cidr_block  = "10.1.0.0/16"
azs         = ["ap-northeast-2a", "ap-northeast-2c"]

create_igw        = true
create_nat_gw     = true
nat_gateway_count = 2

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

# SG
security_groups = [
  { name = "alb-sg",        description = "Allow HTTP/HTTPS from anywhere" },
  { name = "web-sg",        description = "Allow traffic from ALB" },
  { name = "alb-app-sg",    description = "Internal ALB for app layer" },
  { name = "app-sg",        description = "Allow traffic from app alb" },
  { name = "db-sg",         description = "Allow traffic from app" },
]

security_group_rules = [
  # ALB ingress from public
  {
    name                  = "alb-https"
    type                  = "ingress"
    from_port             = 443
    to_port               = 443
    protocol              = "tcp"
    security_group_name   = "alb-sg"
    cidr_blocks           = ["0.0.0.0/0"]
  },
  {
    name                  = "alb-http"
    type                  = "ingress"
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    security_group_name   = "alb-sg"
    cidr_blocks           = ["0.0.0.0/0"]
  },

  # web from bastion
  {
    name                  = "web-from-bastion"
    type                  = "ingress"
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    security_group_name   = "web-sg"
    source_sg_name        = "bastion-sg"
  },
  # web from alb
  {
    name                  = "web-from-alb"
    type                  = "ingress"
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    security_group_name   = "web-sg"
    source_sg_name        = "alb-sg"
  },

  # alb-app from web
  {
    name                  = "alb-app-from-web"
    type                  = "ingress"
    from_port             = 8080
    to_port               = 8080
    protocol              = "tcp"
    security_group_name   = "alb-app-sg"
    source_sg_name        = "web-sg"
  },

  # app from alb-app
  {
    name                  = "app-from-alb-app"
    type                  = "ingress"
    from_port             = 8080
    to_port               = 8080
    protocol              = "tcp"
    security_group_name   = "app-sg"
    source_sg_name        = "alb-app-sg"
  },

  # db from app
  {
    name                  = "db-from-app"
    type                  = "ingress"
    from_port             = 3306
    to_port               = 3306
    protocol              = "tcp"
    security_group_name   = "db-sg"
    source_sg_name        = "app-sg"
  }
]

# ALB
web_name = "dev-web"

web_internal = false

web_port = 80

app_name = "dev-app"

app_internal = true

app_port = 8080

target_type = "instance"

health_check = {
  path = "/"
  protocol = "HTTP"
  matcher = "200"
  interval = 20
  timeout = 3
  healthy_threshold = 3
  unhealthy_threshold = 2
}

protocol = "HTTP"

load_balancer_type = "application"

## EC2 (단일 인스턴스 생성 시 사용)
# key_name = "KTB-personal-project-keypair"

# ami_id = "ami-062cddb9d94dcf95d"

# instance_type = "t3.micro"

# web_ec2_name = "web"

# app_ec2_name = "app"

# ASG
ami_id = "ami-062cddb9d94dcf95d"

instance_type = "t3.micro"

key_name = "KTB-personal-project-keypair"

desired_capacity = 1

min_size = 1

max_size = 2

web_user_data = <<-EOT
#!/bin/bash
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<h1>Web EC2 (Auto Scaling)</h1>" > /var/www/html/index.html
EOT

app_user_data = <<-EOT
#!/bin/bash
yum install -y java-1.8.0-openjdk
echo "SpringBoot App EC2 (Auto Scaling)" > /home/ec2-user/app.log
EOT
