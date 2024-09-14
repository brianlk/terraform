variable "tenant" {
  type        = string
  description = "Deployment tenant"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "aws_route53_private_zone_id" {
  type        = string
  description = "Private zone Id for AWS account - Route53"
}

variable "aws_vpc_subnet_id" {
  type        = string
  description = "Subnet in which EC2 instance will be added"
}

variable "aws_vpc_iface_security_groups" {
  type        = list(string)
  description = "List of security groups to link to the EC2 instance interface"
}

variable "aws_ec2_instance_type" {
  type        = string
  description = "EC2 instance type that will be added"
}

variable "aws_iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile that will be linked to EC2 instance"
}

variable "aws_key_pair_deployer" {
  type        = string
  description = "Name of the key pair to link to the ec2 instance"
}
