variable "name" {
  type = string
}

variable "internal" {
  type        = bool
  description = "true면 내부 ALB, false면 외부 ALB"
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "target_port" {
  type        = number
  description = "Target EC2의 포트 (예: 80 또는 8080)"
}

variable "health_check_path" {
  type        = string
  description = "Health check 경로 (예: /health, /)"
}
