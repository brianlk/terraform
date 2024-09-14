resource "aws_network_interface" "this" {
  subnet_id       = var.aws_vpc_subnet_id
  security_groups = var.aws_vpc_iface_security_groups
  lifecycle {
    ignore_changes = [attachment]
  }
}
