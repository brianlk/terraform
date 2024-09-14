# environment          = "prod"
# region               = "us-east-1"
instance_type        = "t3.medium"
ami_type             = "AL2_x86_64"
key_pair_name        = "SGW"
kubeconfig_folder    = "/tmp/.kube"

# RDS
db_engine_version    = "16.1"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_port              = 5432

# MongoDB
mongodb_org_id                   = "6672974de21b2b0943ccb52c"
mongodb_cluster_atlas_cidr_block = "192.168.0.0/21"

mongodb_clusters = [
  {
    "cluster_name" : "mqtt-broker",
    "cluster_vpc_cidr" : "192.168.1.0/24",
  },
  {
    "cluster_name" : "applications",
    "cluster_vpc_cidr" : "192.168.2.0/24",
  }
]

mongodb_whitelist_ip = [
  {
    "cidr_block" : "109.235.39.196/32",
    "comment" : "SGWireless B.V. Office - Netherlands"
  }
]