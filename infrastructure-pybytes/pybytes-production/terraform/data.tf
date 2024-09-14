data "aws_secretsmanager_secret_version" "mongodb_credentials" {
  secret_id = "pybytes/production/terraform"
}
