variable "ami_type" {
  type = string
}

variable "name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable  "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "tags" {}

variable "key_pair_name" {
  type = string
}
