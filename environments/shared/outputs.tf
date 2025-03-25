output "bastion_instance_id" {
  value = module.ec2_bastion.instance_id
}

output "bastion_public_ip" {
  value = module.ec2_bastion.public_ip
}

output "bastion_private_ip" {
  value = module.ec2_bastion.private_ip
}

output "bastion_sg_id" {
  value = module.sg.security_group_ids["bastion-sg"]
}