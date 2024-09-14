tenant      = "ctrl"
environment = "staging"

create_compilation_api = false

cloudflare_public_zone_id = "1efb162a1ee83815613b57f40ec02cdd"

aws_account_id              = "815345548820"
aws_route53_private_zone_id = "Z16D8DC9VCD4P9"
aws_vpc_cidr                = "10.5.0.0/16"
aws_vpc_subnet_cidr         = "10.5.1.0/24"
aws_application_region_name = "eu-west-3"

redis_aws_ec2_instance_type         = "t4g.micro"
message_queue_aws_ec2_instance_type = "t4g.micro"
compilation_aws_ec2_instance_type   = "t3a.micro"
aws_eb_internal_ports = [
  { "name" : "pyauth", "port" : 3200 },
  { "name" : "pyauth-grpc", "port" : 3201 },
  { "name" : "lorabridge-grpc", "port" : 3012 },
  { "name" : "pybill", "port" : 3010 },
  { "name" : "logger", "port" : 3014 },
  { "name" : "pystats", "port" : 3019 },
  { "name" : "pyconfig", "port" : 5000 },
  { "name" : "api", "port" : 3000 },
  { "name" : "api-grpc", "port" : 3202 },
  { "name" : "pki", "port" : 3013 },
  { "name" : "mqtt", "port" : 3003 },
  { "name" : "mqtt_broker", "port" : 1884 },
  { "name" : "compilation_api", "port" : 8000 },
  { "name" : "redis", "port" : 6379 },
  { "name" : "rabbitmq", "port" : 5672 }
]

aws_eb_environments = [
  { "id" : "pybytes-portal", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pyauth", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pybytes-api", "instance_type" : "t4g.medium", "mqtt-group" : false },
  { "id" : "pybytes-admin-portal", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pybytes-mqtt", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pybytes-mqtt-proxy", "instance_type" : "t4g.micro", "mqtt-group" : true },
  { "id" : "pybytes-mqtt-broker", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pyconfig", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pybytes-pki", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pybytes-logger", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pystats", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "lorabridge", "instance_type" : "t4g.micro", "mqtt-group" : false },
  # { "id" : "pybytes-public-api", "instance_type" : "t4g.micro" },
]

custom_domain_names = [
  { "id" : "pybytes-portal", "url" : "ctrl.sgwireless.com" },
  { "id" : "pybytes-api", "url" : "api.staging.ctrl.sgwireless.com" },
  { "id" : "pybytes-mqtt-proxy", "url" : "mqtt.staging.ctrl.sgwireless.com" },
  { "id" : "lorabridge", "url" : "bridge.staging.ctrl.sgwireless.com" },
]

mongodb_org_id                   = "5a7314350bd66b2b4f3a0b70"
mongodb_cluster_atlas_cidr_block = "192.168.0.0/21"
mongodb_cluster_cluster_region   = "EU_WEST_3"
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

mongodb_databases = [
  "admin",
  "mqttserver",
  "pyauth",
  "pybytes_api",
  "pybytes_logger",
  "pybytes_pki",
  "pyconfig",
  "pystats",
  "mqtt_broker",
]

mongodb_whitelist_ip = [
  {
    "cidr_block" : "109.235.39.196/32",
    "comment" : "SGWireless B.V. Office - Netherlands"
  }
]
