resource "aws_db_subnet_group" "ctrl-pg-subnet-group" {
  name       = "${var.tenant}-${var.environment}-web-db"
  subnet_ids = [var.private_subnet_1, var.private_subnet_2]

  tags = {
    Name = "ctrl-pg"
  }
}

