# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform/OpenTofu that provides extra tools for working with multiple modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
  environment   = local.environment_vars.locals.environment

  # DevOps Account ID IBK
  devops-account-id = "481665099975"

  # Project parameters
  cloud_provider = "aw"
  app_name = "app"
  app_name_lower = lower(local.app_name)
  environment_upper = upper(local.environment)
  i_gp = local.environment_vars.locals.i_gp
  # Correlative number for the environment
  correlative = "01"
}
# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"

  # Only these AWS Account IDs may be operated on by this template
  #allowed_account_ids = ["${local.account_id}"]

    # Validation para asumir el rol de la cuentas de la organización (cuentas hijas)
    assume_role {
        role_arn = "arn:aws:iam::${local.account_id}:role/aw-${local.environment}-iam-${local.app_name_lower}-r-azuredevops-iac-execution-01"
    }
    default_tags {
        tags = {
            I_SIGLA = "${local.app_name}"
            I_GP = "${local.i_gp}"
            I_AMBIENTE = "${local.environment_upper}"
        }
    }
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terragrunt-${local.environment}-${local.devops-account-id}-tf-state-${local.aws_region}"
    key            = "${local.app_name_lower}/${path_relative_to_include()}/tf.tfstate"
    region         = local.aws_region
    dynamodb_table = "terragrunt-${local.environment}-tf-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# # Configure what repos to search when you run 'terragrunt catalog'
# catalog {
#   urls = [
#     "https://github.com/gruntwork-io/terragrunt-infrastructure-modules-example",
#     "https://github.com/gruntwork-io/terraform-aws-utilities",
#     "https://github.com/gruntwork-io/terraform-kubernetes-namespace"
#   ]
# }

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
  {
    # Define global variables here
    cloud_provider = local.cloud_provider
    app_name = local.app_name_lower
    correlative = local.correlative
  }
)
