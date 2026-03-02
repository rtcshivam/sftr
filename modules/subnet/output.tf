output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [for subnet in aws_subnet.subnets : subnet.id]
}
