variable "tenant" {
  type        = string
  description = "Deployment tenant"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account Id"
}

variable "aws_vpc_id" {
  type        = string
  description = "VPC id in which security groups will be created"
}

variable "aws_vpc_cidr" {
  type        = string
  description = "AWS VPC cidr"
}

variable "aws_vpc_subnet_cidr" {
  type        = string
  description = "CIDR vpc subnet"
}

variable "aws_vpc_route_table_id" {
  type        = string
  description = "AWS route table obtained from networking module"
}


variable "aws_app_region_name" {
  type        = string
  description = "Region of AWS applications instances"
}

variable "aws_iam_role_arn" {
  type        = string
  description = "IAM role that will be authorized to access the cluster"
}

variable "mongodb_project_name" {
  type        = string
  description = "The name of the project"
}

variable "mongodb_org_id" {
  type        = string
  description = "Organization Id"
}

variable "mongodb_clusters" {
  description = "List of MongoDB clusters to add"
  type = list(object({
    cluster_name       = string
    cluster_db_version = string
    cluster_region     = string
    size_name          = string
    cluster_size       = number
    backup_enabled     = bool
    cluster_vpc_cidr   = string
  }))
}

variable "mongodb_whitelist_ip" {
  description = "List of whitelisted ip to access MongoDB clusters"
  type = list(object({
    cidr_block = string
    comment    = string
  }))
}

variable "mongodb_cluster_atlas_cidr_block" {
  type        = string
  description = "For ne project we create one network container with CIDR Block"
}

variable "mongodb_cluster_cluster_region" {
  type        = string
  description = "Same Region for all clusters in one project"
}


variable "mongodb_databases" {
  type        = list(string)
  description = "List od databases where application has a R/W access"
}
