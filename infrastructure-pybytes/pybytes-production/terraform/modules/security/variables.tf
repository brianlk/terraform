variable "aws_vpc_id" {
  type        = string
  description = "VPC id in which security groups will be created"
}

variable "aws_vpc_subnet_cidr" {
  type        = string
  description = "CIDR of redis subnet. Needed to allow redis traffic"
}

variable "aws_eb_internal_ports" {
  type        = list(any)
  description = "List of ports needed by microservices to authorize internally"
}
