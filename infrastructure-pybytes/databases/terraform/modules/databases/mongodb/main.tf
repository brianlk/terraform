resource "mongodbatlas_advanced_cluster" "this" {
  for_each = { for cluster in var.mongodb_clusters : cluster.cluster_name => cluster }

  project_id   = mongodbatlas_project.this.id
  name         = "${each.key}-${var.tenant}-${var.environment}"
  cluster_type = "REPLICASET"

  replication_specs {
    num_shards = 1
    region_configs {
      provider_name = "AWS"
      electable_specs {
        instance_size = each.value["size_name"]
        node_count    = 3
      }
      analytics_specs {
        instance_size = each.value["size_name"]
        node_count    = 1
      }

      region_name = each.value["cluster_region"]
      priority    = 7
    }
  }

  mongo_db_major_version = each.value["cluster_db_version"]
  backup_enabled         = each.value["backup_enabled"]
  disk_size_gb           = each.value["cluster_size"]
}
