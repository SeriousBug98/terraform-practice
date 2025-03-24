output "web_instance_public_ip" {
  value = module.ec2_web.public_ip
}

output "app_instance_private_ip" {
  value = module.ec2_app.private_ip
}

output "web_alb_dns_name" {
  value = aws_lb.web.dns_name
}
