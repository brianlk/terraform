
resource "mongodbatlas_database_user" "authorize_iam_role" {
  username           = var.aws_iam_role_arn
  project_id         = var.mongodb_project_id
  auth_database_name = "$external"
  aws_iam_type       = "ROLE"

  dynamic "roles" {
    for_each = var.mongodb_databases
    content {
      role_name     = "readWrite"
      database_name = roles.value
    }

  }

}

