resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = var.name })
}

resource "aws_internet_gateway" "this" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "this" {
  for_each = {
    for subnet in var.subnets :
    "${subnet.az}-${subnet.cidr}" => subnet
  }
  
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.type == "public"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.value.type}-${each.value.az}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = {
    for az in toset(var.azs) : az => {
      subnet = one([
        for k, s in aws_subnet.this : s.id
        if s.map_public_ip_on_launch && s.availability_zone == az
      ])
    }
    if var.create_nat_gw && length([
      for k, s in aws_subnet.this : s.id
      if s.map_public_ip_on_launch && s.availability_zone == az
    ]) > 0
  }

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.subnet

  tags = merge(var.tags, { Name = "${var.name}-natgw-${each.key}" })
}

resource "aws_eip" "nat" {
  for_each = var.create_nat_gw ? toset(var.azs) : toset([])
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  for_each = {
    for k, s in aws_subnet.this : k => s if s.map_public_ip_on_launch
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table" "private" {
  for_each = {
    for az in toset(var.azs) : az => {
      az         = az
      nat_gw_id  = aws_nat_gateway.this[az].id
    }
    if var.create_nat_gw
  }

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.nat_gw_id
  }

  tags = merge(var.tags, { Name = "${var.name}-private-rt-${each.key}" })
}

resource "aws_route_table_association" "private" {
  for_each = {
    for k, s in aws_subnet.this : k => s if !s.map_public_ip_on_launch
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.value.availability_zone].id
}