output "security_group_id" {
  description = "Security group id"
  value       = aws_security_group.security_group.id
}

output "security_group_arn" {
  description = "Security group arn"
  value       = aws_security_group.security_group.arn
}