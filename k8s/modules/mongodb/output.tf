output "cluster_details" {
  value = {
    cluster_names = { for k, v in mongodbatlas_advanced_cluster.this : k => v.name }
    cluster_hosts = { for k, v in mongodbatlas_advanced_cluster.this : k => v.connection_strings[0].standard_srv }
  }
}
