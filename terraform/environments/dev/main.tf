# Automatically discovers the latest Ubuntu 24.04 LTS (Noble Numbat) AMI
# from Canonical. Override with var.ami_id if needed.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
}

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  single_nat_gateway = var.single_nat_gateway
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  app_port         = var.app_port
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  app_port          = var.app_port
  security_group_id = module.security_groups.alb_security_group_id
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc_id
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
}

module "bastion" {
  source = "../../modules/bastion"

  project_name              = var.project_name
  ami_id                    = local.ami_id
  instance_type             = var.instance_type
  subnet_id                 = module.vpc.public_subnet_ids[0]
  security_group_id         = module.security_groups.bastion_security_group_id
  key_pair_name             = var.key_pair_name
  enable_bastion            = var.enable_bastion
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
}

module "backend_asg" {
  source = "../../modules/backend-asg"

  project_name              = var.project_name
  ami_id                    = local.ami_id
  instance_type             = var.instance_type
  key_pair_name             = var.key_pair_name
  app_port                  = var.app_port
  asg_desired_capacity      = var.asg_desired_capacity
  asg_min_size              = var.asg_min_size
  asg_max_size              = var.asg_max_size
  cpu_alarm_threshold       = var.cpu_alarm_threshold
  vpc_private_subnet_ids    = module.vpc.private_subnet_ids
  security_group_id         = module.security_groups.private_ec2_security_group_id
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
  target_group_arn          = module.alb.target_group_arn
}
