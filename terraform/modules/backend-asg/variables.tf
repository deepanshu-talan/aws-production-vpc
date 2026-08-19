variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "ami_id" {
  description = "AMI ID used by the application instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_pair_name" {
  description = "Name of an existing AWS EC2 Key Pair"
  type        = string
}

variable "app_port" {
  description = "Port the Flask application listens on"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired number of instances"
  type        = number
}

variable "asg_min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum number of instances"
  type        = number
}

variable "cpu_alarm_threshold" {
  description = "CPU % threshold that triggers the CloudWatch alarm"
  type        = number
}

variable "vpc_private_subnet_ids" {
  description = "List of private subnet IDs for the ASG"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for private EC2 instances"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}
