# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "sbx"
  i_gp = "SAN_SBX_D012025-xx_xxxx_042025"
}