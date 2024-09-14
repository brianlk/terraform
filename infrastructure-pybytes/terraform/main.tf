terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket = "pycom-terraform"
    key    = "deploy-pybytes"
    region = "eu-west-3"
  }
}

module "s3" {
  source      = "./modules/s3"
  tenant      = var.tenant
  environment = var.environment
}

module "networking" {
  source                      = "./modules/networking"
  vpc_cidr                    = var.aws_vpc_cidr
  subnet_cidr                 = var.aws_vpc_subnet_cidr
  aws_route53_private_zone_id = var.aws_route53_private_zone_id
  private_subnet_1_cidr       = var.private_subnet_1_cidr
  private_subnet_2_cidr       = var.private_subnet_2_cidr
}

module "security" {
  source                = "./modules/security"
  environment           = var.environment
  tenant                = var.tenant
  aws_vpc_id            = module.networking.aws_vpc_id
  aws_vpc_subnet_cidr   = var.aws_vpc_subnet_cidr
  aws_eb_internal_ports = var.aws_eb_internal_ports
}


module "redis" {
  source                                    = "./modules/redis"
  aws_vpc_subnet_id                         = module.networking.aws_vpc_subnet_id
  aws_vpc_id                                = module.networking.aws_vpc_id
  environment                               = var.environment
  tenant                                    = var.tenant
  aws_iam_instance_profile_name_pybytes_app = module.security.aws_iam_instance_profile_name_pybytes_app
  aws_vpc_iface_security_groups             = [module.security.aws_sg_allow_https_from_internet_id, module.security.aws_sg_allow_ssh_from_pycom, module.security.aws_sg_allow_internet_access, module.security.aws_sg_allow_internal_traffic]
  aws_ec2_ssh_private_key                   = pathexpand("~/.ssh/${var.tenant}-${var.environment}-key")
  aws_route53_private_zone_id               = var.aws_route53_private_zone_id
  aws_ec2_instance_type                     = var.redis_aws_ec2_instance_type
  cloudflare_public_zone_id                 = var.cloudflare_public_zone_id
  aws_key_pair_deployer                     = module.security.aws_key_pair_deployer
}

module "elastic_beanstalk" {
  source                      = "./modules/elastic_beanstalk"
  environment                 = var.environment
  production                  = var.production
  custom_domain_names         = var.custom_domain_names
  tenant                      = var.tenant
  aws_iam_app_role_arn        = module.security.aws_iam_role_arn_pybytes_app
  aws_iam_app_role_name       = module.security.aws_iam_role_name_pybytes_app
  aws_eb_environments         = var.aws_eb_environments
  aws_mqtt_security_group_id  = module.security.aws_sg_allow_mqtt_from_internet
  aws_eb_security_groups_id   = "${module.security.aws_sg_allow_internal_traffic},${module.security.aws_sg_allow_ssh_from_pycom},${module.security.aws_sg_allow_https_from_internet_id}"
  aws_aws_vpc_id              = module.networking.aws_vpc_id
  aws_vpc_subnet_id           = module.networking.aws_vpc_subnet_id
  aws_route53_private_zone_id = var.aws_route53_private_zone_id
  cloudflare_public_zone_id   = var.cloudflare_public_zone_id
  aws_key_pair_deployer       = module.security.aws_key_pair_deployer
}

module "message_queue" {
  source                        = "./modules/message_queue"
  tenant                        = var.tenant
  environment                   = var.environment
  aws_route53_private_zone_id   = var.aws_route53_private_zone_id
  aws_vpc_subnet_id             = module.networking.aws_vpc_subnet_id
  aws_vpc_iface_security_groups = [module.security.aws_sg_allow_https_from_internet_id, module.security.aws_sg_allow_ssh_from_pycom, module.security.aws_sg_allow_internet_access, module.security.aws_sg_allow_internal_traffic]
  aws_ec2_instance_type         = var.message_queue_aws_ec2_instance_type
  aws_iam_instance_profile_name = module.security.aws_iam_instance_profile_name_pybytes_app
  aws_key_pair_deployer         = module.security.aws_key_pair_deployer
}
