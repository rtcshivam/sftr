output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = module.bastion.public_ip
}

output "alb_dns_name" {
  value = module.alb.dns_name
}