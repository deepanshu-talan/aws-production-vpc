output "alb_security_group_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "bastion_security_group_id" {
  description = "Security group ID for the Bastion host"
  value       = aws_security_group.bastion.id
}

output "private_ec2_security_group_id" {
  description = "Security group ID for private EC2 instances"
  value       = aws_security_group.private_ec2.id
}
