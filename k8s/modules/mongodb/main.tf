data "aws_caller_identity" "current" {}

locals {
  mongodb_databases = [
    "admin",
    "ctrl-gateway",
    "pyauth",
    "mqttserver",
    "mqtt_broker",
  ]
  cluster_db_version = "7.0"
  instance_size = "M10"
}

resource "mongodbatlas_project" "this" {
  org_id = var.mongodb_org_id
  name   = var.mongodb_project_name
}

resource "mongodbatlas_advanced_cluster" "this" {
  for_each     = { for cluster in var.mongodb_clusters : cluster.cluster_name => cluster }

  project_id   = mongodbatlas_project.this.id
  name         = "${each.key}-${var.mongodb_name}"
  cluster_type = "REPLICASET"

  replication_specs {
    num_shards = 1
    region_configs {
      provider_name = "AWS"
      electable_specs {
        instance_size = local.instance_size
        node_count    = 3
      }
      analytics_specs {
        instance_size = local.instance_size
        node_count    = 1
      }

      region_name = upper(replace(var.cluster_region, "-", "_"))
      priority    = 7
    }
  }

  mongo_db_major_version = local.cluster_db_version
  backup_enabled         = true
  # disk_size_gb           = each.value["cluster_size"]
}


resource "mongodbatlas_database_user" "authorize_iam_role" {
  username           = var.aws_iam_role_arn
  project_id         = mongodbatlas_project.this.id
  auth_database_name = "$external"
  aws_iam_type       = "ROLE"

  dynamic "roles" {
    for_each = local.mongodb_databases
    content {
      role_name     = "readWrite"
      database_name = roles.value
    }
  }
}

resource "mongodbatlas_project_ip_access_list" "access_from_app_subnet" {
  project_id = mongodbatlas_project.this.id
  cidr_block = var.aws_vpc_cidr
  comment    = "Access from app subnet"
}

resource "mongodbatlas_project_ip_access_list" "this" {
  for_each   = { for ip_obj in var.mongodb_whitelist_ip : ip_obj.cidr_block => ip_obj }
  project_id = mongodbatlas_project.this.id
  cidr_block = each.value["cidr_block"]
  comment    = each.value["comment"]
}

resource "mongodbatlas_network_container" "this" {
  project_id       = mongodbatlas_project.this.id
  atlas_cidr_block = var.mongodb_cluster_atlas_cidr_block
  provider_name    = "AWS"
  region_name      = upper(replace(var.cluster_region, "-", "_"))
}

resource "mongodbatlas_network_peering" "this" {
  project_id             = mongodbatlas_project.this.id
  container_id           = mongodbatlas_network_container.this.container_id
  provider_name          = "AWS"
  aws_account_id         = data.aws_caller_identity.current.account_id
  vpc_id                 = var.aws_vpc_id
  route_table_cidr_block = var.aws_vpc_cidr
  accepter_region_name   = var.cluster_region
}

resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = mongodbatlas_network_peering.this.connection_id
  auto_accept               = true
  tags                      = { Side = "Accepter" }
}

resource "aws_route" "this" {
  count                     = length(var.public_route_table_ids)
  vpc_peering_connection_id = mongodbatlas_network_peering.this.connection_id
  route_table_id            = var.public_route_table_ids[count.index]
  destination_cidr_block    = var.mongodb_cluster_atlas_cidr_block
}

