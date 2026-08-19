variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "aws-vpc-project"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# Network
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Map of AZ to CIDR block for public subnets"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.0.1.0/24"
    "ap-south-1b" = "10.0.2.0/24"
  }
}

variable "private_subnets" {
  description = "Map of AZ to CIDR block for private subnets"
  type        = map(string)
  default = {
    "ap-south-1a" = "10.0.11.0/24"
    "ap-south-1b" = "10.0.12.0/24"
  }
}

variable "single_nat_gateway" {
  description = "Use one shared NAT Gateway instead of one per AZ (lower cost, reduced HA)"
  type        = bool
  default     = false
}

# Compute
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Custom AMI ID. Leave empty to use the latest Ubuntu 24.04 LTS AMI"
  type        = string
  default     = ""
}

variable "app_port" {
  description = "Port the Flask application listens on"
  type        = number
  default     = 8000
}

# Auto Scaling
variable "asg_desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

# Security
variable "key_pair_name" {
  description = "Name of an existing AWS EC2 Key Pair to attach to instances"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "List of CIDR blocks allowed to SSH into the Bastion Host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_bastion" {
  description = "Set to false to skip Bastion Host creation"
  type        = bool
  default     = true
}

# Monitoring
variable "cpu_alarm_threshold" {
  description = "CPU % threshold that triggers the CloudWatch alarm"
  type        = number
  default     = 70
}
