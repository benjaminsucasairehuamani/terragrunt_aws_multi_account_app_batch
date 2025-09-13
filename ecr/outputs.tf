
output "aws_ecr_repository_id" {
    description = "ECR repository id"
    value       = aws_ecr_repository.images[0].id
}
output "aws_ecr_repository_arn" {
    description = "ECR repository arn"
    value       = aws_ecr_repository.images[0].arn
}
