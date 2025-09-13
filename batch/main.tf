# Locals section
locals {
  resource_name_environment = "${var.cloud_provider}-${var.environment}-batch-${var.app_name}-env-${var.resource_suffix}-${var.correlative}"
  resource_name_queue = "${var.cloud_provider}-${var.environment}-batch-${var.app_name}-queue-${var.resource_suffix}-${var.correlative}"
  resource_name_definition = "${var.cloud_provider}-${var.environment}-batch-${var.app_name}-definition-${var.resource_suffix}-${var.correlative}"
}

# Resources section

resource "aws_batch_compute_environment" "sample" {
  count = var.create ? 1 : 0
  name = local.resource_name_environment

  compute_resources {
    max_vcpus = 8

    security_group_ids = var.security_groups

    subnets = var.subnets

    type = "FARGATE"
  }

  service_role = var.aws_batch_service_role
  type         = "MANAGED"
  tags = merge(
    {
      Name = local.resource_name_environment
    }
  )
}
resource "aws_batch_job_queue" "test_queue" {
  count = var.create ? 1 : 0
  name     = local.resource_name_queue
  state    = "ENABLED"
  priority = 1

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.sample[0].arn
  }
}
##########################################
# Jon definitions
##########################################


resource "aws_batch_job_definition" "test" {
  name = local.resource_name_definition
  type = "container"

  platform_capabilities = [
    "FARGATE",
  ]

  container_properties = jsonencode({
    image      = var.image_uri
    jobRoleArn = var.ecs_task_role

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    executionRoleArn = var.ecs_task_execution_role
  })
}