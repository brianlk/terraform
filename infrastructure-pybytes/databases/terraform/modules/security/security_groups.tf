provider "aws" {
  profile = "default"
}

resource "aws_security_group" "ctrl-db-sg" {
  name        = "${var.tenant}-${var.environment}-db-sg"
  description = "Allow traffic to RDS instance"
  vpc_id      = var.aws_vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ec2_security_group]
  }
}

