data "aws_secretsmanager_secret_version" "terraform_credentials" {
  secret_id = "${var.tenant}/${var.environment}/terraform"
  provider  = aws.frankfurt
}
