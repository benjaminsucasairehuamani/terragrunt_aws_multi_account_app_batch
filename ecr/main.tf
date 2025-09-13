# Locals section
locals {
  resource_name = "${var.cloud_provider}-${var.environment}-ecr-${var.app_name}-${var.resource_suffix}-${var.correlative}"
}

# Resources section

resource "aws_ecr_repository" "images" {
  count = var.create ? 1 : 0

  name                 = local.resource_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
    kms_key         = var.repository_kms_key
  }

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }


  tags = merge(
    {
      Name = local.resource_name
    }
  )
}

################################################################################
# Lifecycle Policy
################################################################################

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create && var.create_lifecycle_policy ? 1 : 0

  repository = local.resource_name
  policy     = var.repository_lifecycle_policy
}