variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of AZ to CIDR block for public subnets"
  type        = map(string)
}

variable "private_subnets" {
  description = "Map of AZ to CIDR block for private subnets"
  type        = map(string)
}

variable "single_nat_gateway" {
  description = "Use one shared NAT Gateway instead of one per AZ"
  type        = bool
}
