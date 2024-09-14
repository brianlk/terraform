variable "environment" {
  type = string
}

variable "tenant" {
  type = string
}

variable "aws_iam_app_role_arn" {
  type = string
}

variable "aws_iam_app_role_name" {
  type = string
}

variable "aws_eb_environments" {
  type        = list(any)
  description = "List of all eb envinroment in a json format contains the instance name and size"
}

variable "aws_eb_security_groups_id" {
  type = string
}

variable "aws_mqtt_security_group_id" {
  type = string
}

variable "aws_aws_vpc_id" {
  type = string
}

variable "aws_vpc_subnet_id" {
  type = string
}

variable "aws_route53_private_zone_id" {
  type = string
}

variable "cloudflare_public_zone_id" {
  type = string
}

variable "production" {
  type        = bool
  description = "true on production environments, otherwise false. Is needed to create specific production DNS without the environment"
}

variable "custom_domain_names" {
  type        = list(any)
  description = "List of domain names to customize end urls"

}

variable "aws_key_pair_deployer" {
  type        = string
  description = "Name of the key pair to link to the ec2 instance"
}
