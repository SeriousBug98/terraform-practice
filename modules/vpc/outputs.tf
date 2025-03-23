output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [
    for k, s in aws_subnet.this :
    s.id if s.map_public_ip_on_launch
  ]
}

output "private_subnet_ids" {
  value = [
    for k, s in aws_subnet.this :
    s.id if !s.map_public_ip_on_launch
  ]
}

output "nat_gateway_ids" {
  value = [for ngw in aws_nat_gateway.this : ngw.id]
}

output "internet_gateway_id" {
  value = var.create_igw ? aws_internet_gateway.this[0].id : null
}
