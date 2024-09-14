variable "tenant" {
  type        = string
  description = "Deployment tenant"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account Id"
}

variable "rds_allocated_storage" {
  type        = number
  description = "The allocated storage in gibibytes"
}

variable "rds_max_allocated_storage" {
  type        = number
  description = "The max allocated storage in gibibytes"
}

variable "rds_instance_class" {
  type        = string
  description = "Instance class for the rds"
}

variable "rds_backup_retention_period" {
  type        = number
  description = "Backup retion period"
}
variable "rds_security_group_id" {
  type        = string
  description = "RDS Security Group"
}
variable "private_subnet_1" {
  type        = string
  description = "Private subnet 1"
}

variable "private_subnet_2" {
  type        = string
  description = "Private subnet 2"
}

variable "db_subnet_group_name" {
  type        = string
  description = "DB subnet group name"
}

variable "aws_app_region_name" {
  type        = string
  description = "Region of AWS applications instances"
}

variable "rds_admin_password" {
  type        = string
  description = "RDS admin password"
}

