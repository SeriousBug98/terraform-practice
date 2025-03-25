variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance in"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "ec2_name" {
  type        = string
  description = "Name tag for the instance"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
