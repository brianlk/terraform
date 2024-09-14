
resource "mongodbatlas_database_user" "authorize_iam_role" {
  username           = var.aws_iam_role_arn
  project_id         = mongodbatlas_project.this.id
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

resource "mongodbatlas_project_ip_access_list" "access_from_app_subnet" {
  project_id = mongodbatlas_project.this.id
  cidr_block = var.aws_vpc_subnet_cidr
  comment    = "Access from app subnet"
}

resource "mongodbatlas_project_ip_access_list" "this" {
  for_each = { for ip_obj in var.mongodb_whitelist_ip : ip_obj.cidr_block => ip_obj }

  project_id = mongodbatlas_project.this.id
  cidr_block = each.value["cidr_block"]
  comment    = each.value["comment"]
}
