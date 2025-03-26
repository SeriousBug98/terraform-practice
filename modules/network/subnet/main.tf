resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-public-${each.key}"
    Type = "public"
  }
}

resource "aws_subnet" "web_private" {
  for_each = var.web_private_subnet_cidrs

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.name_prefix}-web-private-${each.key}"
    Type = "web-private"
  }
}

resource "aws_subnet" "app_private" {
  for_each = var.app_private_subnet_cidrs

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.name_prefix}-app-private-${each.key}"
    Type = "app-private"
  }
}

resource "aws_subnet" "db_private" {
  for_each = var.db_private_subnet_cidrs

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.name_prefix}-db-private-${each.key}"
    Type = "db-private"
  }
}
