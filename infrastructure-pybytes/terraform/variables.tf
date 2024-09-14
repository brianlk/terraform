variable "tenant" {
  type = string
}

variable "environment" {
  type = string
}

variable "cloudflare_public_zone_id" {
  type        = string
  description = "Cloudflare zone in which public DNS entry will be added"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account Id"
}

variable "aws_application_region_name" {
  type        = string
  description = "Region of AWS applications instances"
}

variable "aws_route53_private_zone_id" {
  type        = string
  description = "Route53 zone in which private DNS entry will be added"
}

variable "aws_vpc_cidr" {
  type = string
}

variable "aws_vpc_subnet_cidr" {
  type = string
}


variable "aws_eb_environments" {
  type        = list(any)
  description = "List of all eb envinroment in a json format contains the instance name and size"
}

variable "redis_aws_ec2_instance_type" {
  type        = string
  description = "EC2 instance type for Redis"
}

variable "aws_eb_internal_ports" {
  type        = list(any)
  description = "List of ports needed by microservices to authorize internally"

}

variable "custom_domain_names" {
  type        = list(any)
  description = "List of domain names to customize end urls"
}

variable "production" {
  type        = bool
  description = "true on production environments, otherwise false. Is needed to create specific production DNS without the environment"
  default     = false
}


variable "message_queue_aws_ec2_instance_type" {
  type        = string
  description = "EC2 instance type for RabbitMQ"
}

variable "private_subnet_1_cidr" {
  type        = string
  description = "CIDR for private subnet 1"
}

variable "private_subnet_2_cidr" {
  type        = string
  description = "CIDR for private subnet 2"
}
