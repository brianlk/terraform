tenant      = "ctrl"
environment = "dev"

cloudflare_public_zone_id = "036fccbb4745455cfd254849bb36df39"

aws_account_id              = "815345548820"
aws_route53_private_zone_id = "Z16D8DC9VCD4P9"
aws_vpc_cidr                = "10.2.0.0/16"
aws_vpc_subnet_cidr         = "10.2.1.0/24"
aws_application_region_name = "eu-west-3"

redis_aws_ec2_instance_type         = "t4g.micro"
message_queue_aws_ec2_instance_type = "t4g.micro"

aws_eb_internal_ports = [
  { "name" : "ctrl-gateway", "port" : 3000 },
  { "name" : "ctrl-management", "port" : 3005 },
  { "name" : "pyauth", "port" : 3201 },
  { "name" : "mqtt", "port" : 3003 },
  { "name" : "mqtt_broker", "port" : 1884 },
  { "name" : "redis", "port" : 6379 },
  { "name" : "rabbitmq", "port" : 5672 }
]

aws_eb_environments = [
  { "id" : "ctrl-portal", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "ctrl-gateway", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "ctrl-management", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pyauth", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pybytes-mqtt", "instance_type" : "t4g.micro", "mqtt-group" : false },
  { "id" : "pybytes-mqtt-proxy", "instance_type" : "t4g.micro", "mqtt-group" : true },
  { "id" : "pybytes-mqtt-broker", "instance_type" : "t4g.micro", "mqtt-group" : false },
]

custom_domain_names = []

