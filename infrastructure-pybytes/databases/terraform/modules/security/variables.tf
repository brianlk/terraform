variable "ec2_security_group" {
  type        = string
  description = "Security group for EC2 instances"
}

variable "aws_vpc_id" {
  type        = string
  description = "VPC id in which security groups will be created"
}

variable "tenant" {
  type        = string
  description = "Deployment tenant"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

