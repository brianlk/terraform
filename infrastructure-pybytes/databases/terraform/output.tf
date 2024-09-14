output "cluster_names" {
  value = {
    cluster_names = module.mongodb_clusters.cluster_details
  }
}

output "rds_details" {
  value = {
    rds_details = module.postgres_rds.rds_endpoint
  }
}
