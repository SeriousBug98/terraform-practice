resource "aws_eip" "this" {
  for_each = var.public_subnet_ids

  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = var.public_subnet_ids

  allocation_id = aws_eip.this[each.key].id
  subnet_id     = each.value

  tags = {
    Name = "${var.name_prefix}-natgw-${each.key}"
  }

  depends_on = [aws_eip.this]
}
