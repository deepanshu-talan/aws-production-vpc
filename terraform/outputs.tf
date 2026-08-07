output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer — open this in a browser"
  value       = aws_lb.alb.dns_name
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host (null if enable_bastion = false)"
  value       = var.enable_bastion ? aws_instance.bastion[0].public_ip : null
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.asg.name
}
