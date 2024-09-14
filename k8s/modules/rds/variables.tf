variable "identifier" {
	type = string
}

variable "db_engine_version" {
	type = string
}

variable "db_instance_class" {
	type = string
}
 
variable "db_allocated_storage" {
	type = string
}

variable "db_name" {
	type = string
}

variable "db_username" {
	type = string
}

# variable "db_password" {
# 	type = string
# }

variable "db_port" {
	type = string
}

variable "db_vpc_security_group_ids" {}

variable "subnet_ids" {}

variable "tags" {}