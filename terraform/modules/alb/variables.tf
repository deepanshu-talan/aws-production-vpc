variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "app_port" {
  description = "Port the Flask application listens on"
  type        = number
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}
