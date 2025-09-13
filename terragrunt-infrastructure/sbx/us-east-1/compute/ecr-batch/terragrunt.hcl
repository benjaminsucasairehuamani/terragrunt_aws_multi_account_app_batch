# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/ecr.hcl"
  # We want to reference the variables from the included config in this configuration, so we expose it.
  expose = true
}
# Configure the version of the module to use in this environment. This allows you to promote new versions one
# environment at a time (e.g., qa -> stage -> prod).
terraform {
  #source = "${include.envcommon.locals.base_source_url}?ref=v0.8.0"
  source = "${include.envcommon.locals.base_source_url}"
}

inputs = {
  resource_suffix = "batch-python3"
  repository_image_scan_on_push = false
  repository_image_tag_mutability = "MUTABLE"
 repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Untagged images must not exist, so they expire if they are more than 3 months old.",
        selection = {
          tagStatus     = "untagged",
          countType     = "sinceImagePushed",
          countUnit     = "days",
          countNumber   = 90
        },
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2,
        description  = "The policy keeps only the 30 most recent images (regardless of whether they have a label or not) and deletes older images when that number is exceeded.",
        selection = {
          tagStatus     = "any",
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
