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
variable "security_group_description" {
    description = "The description of the security group."
    type        = string
  default = "Managed by Terraform"
}
variable "vpc_id" {
    description = "The VPC ID."
    type        = string
}
variable "egress_rules" {
    description = "A list of maps containing egress rules."
    type = list(object({
      description      = string
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
    default = [{
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }]
}

variable "ingress_rules" {
  type = list(object({
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    ipv6_cidr_blocks         = list(string)
    source_security_group_id = string
  }))
  default = [{
    description              = ""
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    cidr_blocks              = []
    ipv6_cidr_blocks         = []
    source_security_group_id = ""
  }]
}