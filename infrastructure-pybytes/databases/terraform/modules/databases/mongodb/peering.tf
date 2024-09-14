resource "mongodbatlas_network_container" "this" {
  project_id       = mongodbatlas_project.this.id
  atlas_cidr_block = var.mongodb_cluster_atlas_cidr_block
  provider_name    = "AWS"
  region_name      = var.mongodb_cluster_cluster_region
}

resource "mongodbatlas_network_peering" "this" {
  project_id             = mongodbatlas_project.this.id
  container_id           = mongodbatlas_network_container.this.container_id
  provider_name          = "AWS"
  aws_account_id         = var.aws_account_id
  vpc_id                 = var.aws_vpc_id
  route_table_cidr_block = var.aws_vpc_cidr
  accepter_region_name   = var.aws_app_region_name
}

resource "aws_vpc_peering_connection_accepter" "this" {
  vpc_peering_connection_id = mongodbatlas_network_peering.this.connection_id
  auto_accept               = true
  tags                      = { Side = "Accepter" }
}


resource "aws_route" "this" {
  vpc_peering_connection_id = mongodbatlas_network_peering.this.connection_id
  route_table_id            = var.aws_vpc_route_table_id
  destination_cidr_block    = var.mongodb_cluster_atlas_cidr_block
}
