output "bastion_public_ip" {
  description = "Public IP of the Bastion host"
  value       = var.enable_bastion ? aws_instance.bastion[0].public_ip : null
}
