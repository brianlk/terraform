# variable "environment" {
#   type = string
# }

# variable "region" {
#   type = string
# }

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "instance_type" {
  type = string
}

variable "ami_type" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "kubeconfig_folder" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}
 
variable "db_allocated_storage" {
  type = string
}

variable "db_port" {
  type = string
}

variable "mongodb_org_id" {
  type = string
}

variable "mongodb_whitelist_ip" {}

# variable "public_route_table_ids" {}


variable "mongodb_clusters" {}

variable "mongodb_cluster_atlas_cidr_block" {
  type        = string
  description = "For ne project we create one network container with CIDR Block"
}

# variable "mongodb_cluster_cluster_region" {
#   type        = string
#   description = "Same Region for all clusters in one project"
# }
