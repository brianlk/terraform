variable "aws_eb_environments" {
  type        = list(any)
  description = "List of all eb envinroment in a json format contains the instance name and size"
}

variable "custom_domain_names" {
  type        = list(any)
  description = "List of domain names to customize end urls"

}

variable "aws_vpc_id" {
  type        = string
  description = "VPC id in which security groups will be created"
}

variable "aws_vpc_subnet_id" {
  type = string
}

variable "aws_vpc_subnet_cidr" {
  type        = string
  description = "CIDR of redis subnet. Needed to allow redis traffic"
}

variable "aws_eb_internal_ports" {
  type        = list(any)
  description = "List of ports needed by microservices to authorize internally"
}

variable "mongodb_project_id" {
  type        = string
  description = "Atlas project id"
}

variable "mongodb_databases" {
  type        = list(string)
  description = "MongoDB databases that will be authorized"
}

variable "aws_route53_private_zone_id" {
  type        = string
  description = "id of the private zone in which the redis fqdn will be created"
}

variable "cloudflare_public_zone_id" {
  type = string
}
