data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

# Create VPC using Terraform Module
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"

  # Details
  name                 = "${var.name}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = local.azs
  public_subnets       = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets      = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]

  # NAT Gateways - Outbound Communication
  enable_nat_gateway   = true
  single_nat_gateway   = true

  # DNS Parameters in VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Additional tags for the VPC
  tags                 = var.tags
  # vpc_tags = local.tags

  # Additional tags
  # Additional tags for the public subnets
  public_subnet_tags = {
    Name                                          = "${var.name}-public-subnets"
    "kubernetes.io/role/elb"                      = 1
    "kubernetes.io/cluster/${var.cls_name}" = "shared"
  }
  # Additional tags for the private subnets
  private_subnet_tags = {
    Name                                          = "${var.name}-private-subnets"
    "kubernetes.io/role/internal-elb"             = 1
    "kubernetes.io/cluster/${var.cls_name}" = "shared"
  }

  private_route_table_tags = {
    Name = "${var.name}-private-route-table"
  }

  public_route_table_tags = {
    Name = "${var.name}-public-route-table"
  }

  default_route_table_tags = {
    Name = "${var.name}-default-route-table"
  }

  igw_tags = {
    Name = "${var.name}-igw"
  }
  # Instances launched into the Public subnet should be assigned a public IP address. Specify true to indicate that instances launched into the subnet should be assigned a public IP address
  map_public_ip_on_launch = true
}

