aws_vpc_id                  = "vpc-939ec3fb"
aws_vpc_subnet_id           = "subnet-61cf2e2c"
aws_vpc_subnet_cidr         = "172.31.0.0/16"
mongodb_project_id          = "5a7314354e65811981ff75dd"
mongodb_databases           = ["admin", "mqttserver", "pyauth", "pybytes_api", "pybytes_logger", "pybytes_pki", "pyconfig", "pystats"]
aws_route53_private_zone_id = "Z16D8DC9VCD4P9"
cloudflare_public_zone_id   = "036fccbb4745455cfd254849bb36df39"

aws_eb_internal_ports = [
  { "name" : "pyauth", "port" : 3200 },
  { "name" : "logger", "port" : 3014 },
  { "name" : "pystats", "port" : 3019 },
  { "name" : "pyconfig", "port" : 5000 },
  { "name" : "api", "port" : 3000 },
  { "name" : "pki", "port" : 3013 },
  { "name" : "mqtt", "port" : 3003 },
  { "name" : "pyauth", "port" : 3200 }
]

custom_domain_names = [
  { "id" : "pybytes-portal", "url" : "pybytes.pycom.io" },
  { "id" : "pybytes-api", "url" : "api.pybytes.pycom.io" },
  { "id" : "pybytes-public-api", "url" : "public-api.pybytes.pycom.io" },
  { "id" : "pybytes-mqtt", "url" : "mqtt.pybytes.pycom.io" },
  { "id" : "pyauth", "url" : "pyauth.pybytes.pycom.io" },
  { "id" : "pyconfig", "url" : "pyconfig.pybytes.pycom.io" },
  { "id" : "lorabridge", "url" : "lorabridge.pybytes.pycom.io" },
  { "id" : "sigfoxbridge", "url" : "sigfoxbridge.pybytes.pycom.io" },
  { "id" : "ttnbridge", "url" : "ttnbridge.pybytes.pycom.io" },
  { "id" : "pybytes-admin-portal", "url" : "admin.pybytes.pycom.io" }
]

aws_eb_environments = [
  { "id" : "pybytes-api", "instance_type" : "t4g.large" },
  { "id" : "pybytes-portal", "instance_type" : "t4g.micro" },
  { "id" : "pybytes-admin-portal", "instance_type" : "t4g.micro" },
  { "id" : "pybytes-pki", "instance_type" : "t4g.micro" },
  { "id" : "pybytes-mqtt", "instance_type" : "t4g.medium" },
  { "id" : "pybytes-logger", "instance_type" : "t4g.micro" },
  { "id" : "pybytes-public-api", "instance_type" : "t4g.medium" },
  { "id" : "pystats", "instance_type" : "t4g.micro" },
  { "id" : "pyauth", "instance_type" : "t4g.medium" },
  { "id" : "pyconfig", "instance_type" : "t4g.medium" },
  { "id" : "sigfoxbridge", "instance_type" : "t4g.micro" },
  { "id" : "ttnbridge", "instance_type" : "t4g.micro" },
  { "id" : "lorabridge", "instance_type" : "t4g.micro" }
]
