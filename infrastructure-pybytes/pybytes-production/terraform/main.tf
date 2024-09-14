terraform {
  required_version = ">= 0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.2"
    }
  }

  backend "s3" {
    bucket = "pycom-terraform"
    key    = "deploy-pybytes-production-custom"
    region = "eu-west-3"
  }
}

module "security" {
  source                = "./modules/security"
  aws_vpc_id            = var.aws_vpc_id
  aws_vpc_subnet_cidr   = var.aws_vpc_subnet_cidr
  aws_eb_internal_ports = var.aws_eb_internal_ports
}

module "mongodb" {
  source             = "./modules/mongodb"
  mongodb_project_id = var.mongodb_project_id
  mongodb_databases  = var.mongodb_databases
  aws_iam_role_arn   = module.security.aws_iam_role_arn_pybytes_app
}

module "elastic_beanstalk" {
  source                      = "./modules/eb"
  aws_eb_environments         = var.aws_eb_environments
  custom_domain_names         = var.custom_domain_names
  aws_iam_app_role_arn        = module.security.aws_iam_role_arn_pybytes_app
  aws_iam_app_role_name       = module.security.aws_iam_role_name_pybytes_app
  aws_mqtt_security_group_id  = module.security.aws_sg_allow_mqtt_from_internet
  aws_eb_security_groups_id   = "${module.security.aws_sg_allow_internal_traffic},${module.security.aws_sg_allow_ssh_from_pycom},${module.security.aws_sg_allow_https_from_internet_id}"
  aws_vpc_id                  = var.aws_vpc_id
  aws_vpc_subnet_id           = var.aws_vpc_subnet_id
  aws_route53_private_zone_id = var.aws_route53_private_zone_id
  cloudflare_public_zone_id   = var.cloudflare_public_zone_id
}

module "s3" {
  source = "./modules/s3"
}
