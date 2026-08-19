variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Bastion host"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID to place the Bastion host in"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for Bastion"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the existing EC2 Key Pair"
  type        = string
}

variable "enable_bastion" {
  description = "Set to false to skip Bastion Host creation"
  type        = bool
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for Bastion"
  type        = string
}
