#############################################
# modules/sg/main.tf (Cycle 완전 차단 구조)
#############################################

# 1단계: 보안 그룹 생성 (룰 없이)
resource "aws_security_group" "this" {
  for_each = { for sg in var.security_groups : sg.name => sg }

  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = each.value.name })
}

resource "aws_security_group_rule" "ref_ingress" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule
    if rule.type == "ingress" && contains(keys(rule), "source_sg_name") && rule.source_sg_name != null
  }

  type                     = "ingress"
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  security_group_id       = aws_security_group.this[each.value.security_group_name].id
  source_security_group_id = aws_security_group.this[each.value.source_sg_name].id
}

resource "aws_security_group_rule" "cidr_ingress" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule
    if rule.type == "ingress" && contains(keys(rule), "cidr_blocks") && rule.cidr_blocks != null
  }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.this[each.value.security_group_name].id
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for sg in var.security_groups : sg.name => sg
  }

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this[each.key].id
  cidr_blocks       = ["0.0.0.0/0"]
}