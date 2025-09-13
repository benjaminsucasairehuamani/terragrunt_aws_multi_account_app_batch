# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/security-group.hcl"
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
  vpc_id = "vpc-035209b60deed7299"
  ingress_rules = [
    {
      description              = "TCP traffic from the VPC"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      cidr_blocks              = ["172.31.0.0/16"]
      ipv6_cidr_blocks         = []
      source_security_group_id = ""
    }
  ]
}