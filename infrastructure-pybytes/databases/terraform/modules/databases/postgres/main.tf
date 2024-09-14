provider "aws" {
  profile = "default"
  region  = var.aws_app_region_name
  default_tags {
    tags = {
      created-by  = "terraform",
      source      = "https://github.com/pycom/pybytes-script",
      Name        = "${var.tenant}-${var.environment}"
      tenant      = var.tenant
      environment = var.environment
    }
  }
}

resource "aws_db_instance" "web_database" {
  allocated_storage                   = var.rds_allocated_storage
  max_allocated_storage               = var.rds_max_allocated_storage
  engine                              = "postgres"
  engine_version                      = "16.1"
  instance_class                      = var.rds_instance_class
  parameter_group_name                = "default.postgres16"
  identifier                          = "${var.tenant}-${var.environment}-web-db"
  db_name                             = "${var.tenant}_${var.environment}_web_db"
  username                            = "${var.tenant}_${var.environment}_web_db_admin_user"
  password                            = var.rds_admin_password
  port                                = 5432
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  deletion_protection                 = false
  vpc_security_group_ids              = [var.rds_security_group_id]
  publicly_accessible                 = false
  backup_retention_period             = var.rds_backup_retention_period
  db_subnet_group_name                = var.db_subnet_group_name
}

