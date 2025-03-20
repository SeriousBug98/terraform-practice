resource "aws_subnet" "public" {
  for_each = { for idx, subnet in var.public_subnets : idx => subnet }

  vpc_id = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${each.key}"
    Environment = var.environment
  }
}
resource "aws_subnet" "private" {
  for_each = { for idx, subnet in var.private_subnets : idx => subnet }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.environment}-private-subnet-${each.key}"
    Environment = var.environment
  }
}