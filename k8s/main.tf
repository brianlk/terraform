terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.6" # which means any version equal & above
    }
  }
  required_version = "> 0.13"

  backend "s3" {
    bucket = "ctrl-k8s-terraform"
    key    = "terraform.tfstate"
    region = "ap-east-1"
  }
}

locals {
  tenant = split("_", "${terraform.workspace}")[0]
  environment = split("_", "${terraform.workspace}")[1]
  region = split("_", "${terraform.workspace}")[2]
  name = "${local.tenant}-${local.environment}"
  tags = {
    tenant       = "${local.tenant}"
    environment  = "${local.environment}"
    created_by   = "terraform"
    Name         = "${local.name}"
    source       = "https://github.com/sg-wireless/infrastructure-pybytes/k8s"
  }
}

provider "aws" {
  region = local.region
  profile = "Ctrl-infrastructure" #AWS Credentials Profile (profile = "default") configured on local
}

# Deploy VPC
module "vpc" {
  source   = "./modules/vpc"
  name     = "${local.name}-vpc"
  vpc_cidr = "10.91.0.0/16"
  tags     = local.tags
  cls_name = "${local.name}-eks"
}

## Deploy EKS
module "eks" {
  source              = "./modules/eks"
  name                = "${local.name}-eks"
  instance_type       = var.instance_type
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  public_subnets      = module.vpc.public_subnets
  tags                = local.tags
  ami_type            = var.ami_type
  key_pair_name       = var.key_pair_name
}

# ## Wirte the kubeconfig to local file
# # module "kubeconfig" {
# #   source            = "./modules/kubeconfig"
# #   eks               = module.eks
# #   kubeconfig_folder = var.kubeconfig_folder
# #   region            = var.region
# # }

# # Deploy Postgresql DB
# module "db" {
#   source                    = "./modules/rds"
#   identifier                = "${local.name}-web-db"
#   db_engine_version         = var.db_engine_version
#   db_instance_class         = var.db_instance_class
#   db_allocated_storage      = var.db_allocated_storage

#   db_name                   = "${local.tenant}${local.environment}webdb"
#   db_username               = "dbadmin"
#   db_port                   = var.db_port
#   db_vpc_security_group_ids = ["${module.eks.node_security_group_id}"]

#   # # DB subnet group
#   subnet_ids                = module.vpc.private_subnets
#   tags                      = local.tags
# }

# # Create Mongodb in Mongoatlas
# module "mongodb" {
#   source                           = "./modules/mongodb"
#   mongodb_org_id                   = var.mongodb_org_id
#   aws_vpc_id                       = module.vpc.vpc_id
#   aws_vpc_cidr                     = module.vpc.vpc_cidr_block
#   mongodb_project_name             = local.name
#   mongodb_clusters                 = var.mongodb_clusters
#   mongodb_name                     = local.name
#   cluster_region                   = local.region
#   aws_iam_role_arn                 = module.eks.app_iam_role_arn
#   subnets                          = module.vpc.public_subnets_cidr_blocks
#   mongodb_cluster_atlas_cidr_block = var.mongodb_cluster_atlas_cidr_block
#   mongodb_whitelist_ip             = var.mongodb_whitelist_ip
#   public_route_table_ids           = module.vpc.public_route_table_ids
# }
