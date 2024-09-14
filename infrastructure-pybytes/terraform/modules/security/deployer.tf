resource "aws_key_pair" "deployer" {
  key_name   = "${var.tenant}-${var.environment}-key"
  public_key = file("~/.ssh/${var.tenant}-${var.environment}-key.pub")
}
