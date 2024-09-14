terraform {
  required_version = ">= 0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.10.2"
    }
  }

  backend "s3" {
    bucket = "pycom-terraform"
    key    = "deploy-ctrl-db"
    region = "eu-west-3"
  }
}

module "mongodb_clusters" {
  source                           = "./modules/databases/mongodb"
  tenant                           = var.tenant
  environment                      = var.environment
  mongodb_org_id                   = var.mongodb_org_id
  mongodb_project_name             = "${var.tenant}-${var.environment}-clusters"
  mongodb_clusters                 = var.mongodb_clusters
  mongodb_cluster_atlas_cidr_block = var.mongodb_cluster_atlas_cidr_block
  mongodb_cluster_cluster_region   = var.mongodb_cluster_cluster_region
  mongodb_whitelist_ip             = var.mongodb_whitelist_ip
  aws_account_id                   = var.aws_account_id
  aws_vpc_id                       = var.aws_vpc_id
  aws_vpc_cidr                     = var.aws_vpc_cidr
  aws_vpc_subnet_cidr              = var.aws_vpc_subnet_cidr
  aws_vpc_route_table_id           = var.aws_vpc_route_table_id
  aws_app_region_name              = var.aws_application_region_name
  aws_iam_role_arn                 = var.aws_iam_role_arn
  mongodb_databases                = var.mongodb_databases
}

module "postgres_rds" {
  source                      = "./modules/databases/postgres"
  tenant                      = var.tenant
  environment                 = var.environment
  aws_account_id              = var.aws_account_id
  aws_app_region_name         = var.aws_application_region_name
  rds_admin_password          = local.terraform_credentials.postgresql_db_password
  rds_allocated_storage       = var.rds_allocated_storage
  rds_max_allocated_storage   = var.rds_max_allocated_storage
  rds_instance_class          = var.rds_instance_class
  rds_backup_retention_period = var.rds_backup_retention_period
  private_subnet_1            = var.private_subnet_1
  private_subnet_2            = var.private_subnet_2
  rds_security_group_id       = module.security.rds_security_group_id
  db_subnet_group_name        = module.networking.aws_db_subnet_group_name
}

module "security" {
  source             = "./modules/security"
  tenant             = var.tenant
  environment        = var.environment
  ec2_security_group = var.ec2_security_group
  aws_vpc_id         = var.aws_vpc_id
}

module "networking" {
  source           = "./modules/networking"
  tenant           = var.tenant
  environment      = var.environment
  private_subnet_1 = var.private_subnet_1
  private_subnet_2 = var.private_subnet_2
}
