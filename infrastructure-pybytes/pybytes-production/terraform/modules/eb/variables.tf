variable "aws_eb_environments" {
  type        = list(any)
  description = "List of all eb envinroment in a json format contains the instance name and size"
}

variable "custom_domain_names" {
  type        = list(any)
  description = "List of domain names to customize end urls"

}

variable "aws_iam_app_role_arn" {
  type = string
}

variable "aws_iam_app_role_name" {
  type = string
}

variable "aws_vpc_id" {
  type        = string
  description = "VPC id in which security groups will be created"
}

variable "aws_vpc_subnet_id" {
  type = string
}

variable "aws_eb_security_groups_id" {
  type = string
}

variable "aws_mqtt_security_group_id" {
  type = string
}

variable "aws_route53_private_zone_id" {
  type        = string
  description = "id of the private zone in which the redis fqdn will be created"
}

variable "cloudflare_public_zone_id" {
  type = string
}
