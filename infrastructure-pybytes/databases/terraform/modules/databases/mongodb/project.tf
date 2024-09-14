resource "mongodbatlas_project" "this" {
  org_id = var.mongodb_org_id
  name   = var.mongodb_project_name
}
