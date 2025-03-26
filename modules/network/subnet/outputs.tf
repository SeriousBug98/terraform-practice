output "public_subnets" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "web_private_subnets" {
  value = [for subnet in aws_subnet.web_private : subnet.id]
}

output "app_private_subnets" {
  value = [for subnet in aws_subnet.app_private : subnet.id]
}

output "db_private_subnets" {
  value = [for subnet in aws_subnet.db_private : subnet.id]
}
