variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups are created"
  type        = string
}

variable "app_port" {
  description = "Application port allowed from the ALB"
  type        = number
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into Bastion"
  type        = list(string)
}
