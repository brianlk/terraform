variable "vpc_cidr" {
  description = "CIDR of the created VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR of the created network"
  type        = string
}

variable "aws_route53_private_zone_id" {
  type        = string
  description = "Id of DNS private zone that will be linked to the VPC"
}

variable "private_subnet_1_cidr" {
  type        = string
  description = "CIDR for private subnet 1"
}

variable "private_subnet_2_cidr" {
  type        = string
  description = "CIDR for private subnet 2"
}
