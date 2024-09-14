tenant      = "ctrl"
environment = "dev"

aws_account_id              = "815345548820"
aws_vpc_cidr                = "10.2.0.0/16"
aws_vpc_subnet_cidr         = "10.2.1.0/24"
aws_vpc_id                  = "vpc-0e39b668bdfb87ca7"
aws_vpc_route_table_id      = "rtb-0cd71bc123fa27926"
aws_iam_role_arn            = "arn:aws:iam::815345548820:role/ctrl-dev-pybytes-app"
aws_application_region_name = "eu-west-3"

mongodb_org_id                   = "5a7314350bd66b2b4f3a0b70"
mongodb_cluster_cluster_region   = "EU_WEST_3"
mongodb_cluster_atlas_cidr_block = "192.168.0.0/21"

mongodb_databases = [
  "admin",
  "ctrl-gateway",
  "pyauth",
  "mqttserver",
  "mqtt_broker",
]


mongodb_clusters = [
  {
    "cluster_name" : "mqtt-broker",
    "cluster_db_version" : "7.0",
    "cluster_region" : "EU_WEST_3",
    "size_name" : "M10",
    "cluster_size" : 10,
    "backup_enabled" : false,
    "cluster_vpc_cidr" : "192.168.1.0/24",
  },
  {
    "cluster_name" : "applications",
    "cluster_db_version" : "7.0",
    "cluster_region" : "EU_WEST_3",
    "size_name" : "M10",
    "cluster_size" : 10,
    "backup_enabled" : false,
    "cluster_vpc_cidr" : "192.168.2.0/24",
  }
]


mongodb_whitelist_ip = [
  {
    "cidr_block" : "109.235.39.196/32",
    "comment" : "SGWireless B.V. Office - Netherlands"
  }
]
