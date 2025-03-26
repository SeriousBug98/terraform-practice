# 퍼블릭 서브넷용 라우트 테이블
resource "aws_route_table" "public" {
  for_each = var.public_subnet_ids

  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.name_prefix}-rt-public-${each.key}"
  }
}

# 퍼블릭 서브넷에 연결
resource "aws_route_table_association" "public" {
  for_each = var.public_subnet_ids

  subnet_id      = each.value
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table" "private" {
  for_each = var.private_subnet_group_az_map

  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_ids[each.key]
  }

  tags = {
    Name = "${var.name_prefix}-rt-private-${each.key}"
  }
}

locals {
  private_route_table_associations = {
    for pair in flatten([
      for az, subnet_ids in var.private_subnet_group_az_map : [
        for idx, subnet_id in subnet_ids : {
          key            = "${az}-${idx}"
          subnet_id      = subnet_id
          route_table_id = aws_route_table.private[az].id
        }
      ]
    ]) : pair.key => {
      subnet_id      = pair.subnet_id
      route_table_id = pair.route_table_id
    }
  }
}


resource "aws_route_table_association" "private" {
  for_each = local.private_route_table_associations

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}
