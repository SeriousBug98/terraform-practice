output "public_route_table_ids" {
  value = { for az, rt in aws_route_table.public : az => rt.id }
}

output "private_route_table_ids" {
  value = { for az, rt in aws_route_table.private : az => rt.id }
}
