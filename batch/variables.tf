variable "cloud_provider" {
  description = "cloud provider"
  type        = string
}
variable "app_name" {
  description = "application name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}
variable "resource_suffix" {
  description = "resource suffix"
  type        = string
}
variable "correlative" {
  description = "correlative"
  type        = string
}
################################################################################
# batch
################################################################################
variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}
variable "security_groups" {
  description = "A list of security group IDs to assign to the LB"
  type        = list(string)
  default     = []
}
variable "subnets" {
    description = "List of subnet IDs associated with the compute resources"
    type        = list(string)
    default     = []
}
variable "aws_batch_service_role" {
    description = "The ARN of the AWS Batch service role"
    type        = string
    default     = ""
}
#################################################################################
# job definition
#################################################################################
variable "ecs_task_execution_role"{
    description = "The ARN of the ECS task execution role that the Amazon ECS container agent and the Docker daemon can assume"
    type        = string
    default     = ""
}
variable "image_uri" {
    description = "The image used to start a container"
    type        = string
    default     = ""
}
variable "ecs_task_role" {
    description = "The ARN of the IAM role that the container can assume"
    type        = string
    default     = ""
}