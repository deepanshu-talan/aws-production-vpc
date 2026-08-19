output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer — open this in a browser"
  value       = module.alb.alb_dns_name
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host (null if enable_bastion = false)"
  value       = var.enable_bastion ? module.bastion.bastion_public_ip : null
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.backend_asg.asg_name
}
