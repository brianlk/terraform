locals {
  engine = "postgres"
}

module "db" {
  source                              = "terraform-aws-modules/rds/aws"

  identifier                          = var.identifier
  engine                              = local.engine
  family                              = "${local.engine}${split(".", var.db_engine_version)[0]}"
  engine_version                      = var.db_engine_version
  instance_class                      = var.db_instance_class
  allocated_storage                   = var.db_allocated_storage

  db_name                             = var.db_name
  username                            = var.db_username
  # password                            = var.db_password
  manage_master_user_password         = true
  port                                = var.db_port

  iam_database_authentication_enabled = true

  vpc_security_group_ids              = var.db_vpc_security_group_ids

  backup_window                       = "03:00-05:00"

  # # DB subnet group
  create_db_subnet_group              = true
  subnet_ids                          = var.subnet_ids
  publicly_accessible                 = false
  skip_final_snapshot                 = true
  deletion_protection                 = true
  backup_retention_period             = 14
  tags                                = var.tags
}