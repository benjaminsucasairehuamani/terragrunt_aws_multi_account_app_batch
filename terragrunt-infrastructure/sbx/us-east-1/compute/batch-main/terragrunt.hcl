# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/batch.hcl"
  # We want to reference the variables from the included config in this configuration, so we expose it.
  expose = true
}
# Configure the version of the module to use in this environment. This allows you to promote new versions one
# environment at a time (e.g., qa -> stage -> prod).
terraform {
  #source = "${include.envcommon.locals.base_source_url}?ref=v0.8.0"
  source = "${include.envcommon.locals.base_source_url}"
}
dependency "security-group-batch" {
  config_path = "../security-group-batch"
  mock_outputs        = {
    security_group_id = "dg-12345678"
  }
}

inputs = {
  resource_suffix = "etl-main"
  security_groups = [dependency.security-group-batch.outputs.security_group_id]
  subnets = ["subnet-0201c2b9ea413c9dd","subnet-0a17a4f35133cd0bd"]
  aws_batch_service_role ="arn:aws:iam::588738574413:role/aws-service-role/batch.amazonaws.com/AWSServiceRoleForBatch"
  image_uri ="588738574413.dkr.ecr.us-east-1.amazonaws.com/aw-sbx-ecr-app-batch-python3-01:latest"
  ecs_task_role = "arn:aws:iam::588738574413:role/ecsTaskExecutionRole"
  ecs_task_execution_role = "arn:aws:iam::588738574413:role/ecsTaskExecutionRole"

}
