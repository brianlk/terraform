
variable "aws_vpc_subnet_id" {
  type        = string
  description = "aws_vpc_subnet_id in which to create the interface"
}

variable "aws_vpc_id" {
  type        = string
  description = "ID of the VPC in which the ec2 instance will be created"
}

variable "tenant" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_iam_instance_profile_name_pybytes_app" {
  type        = string
  description = "name of the instance profile that will be linked to the EC2 instance"
}

variable "aws_vpc_iface_security_groups" {
  type        = list(string)
  description = "List of security groups to link to the interface"
}

variable "aws_ec2_ssh_private_key" {
  type        = string
  description = "Name of the private ssh key to link to the ec2 instance"
}

variable "aws_route53_private_zone_id" {
  type        = string
  description = "id of the private zone in which the redis fqdn will be created"
}

variable "aws_ec2_instance_type" {
  type        = string
  description = "type of ec2 instance to create"
}

variable "cloudflare_public_zone_id" {
  type = string
}

variable "aws_key_pair_deployer" {
  type        = string
  description = "Name of the key pair to link to the ec2 instance"
}
