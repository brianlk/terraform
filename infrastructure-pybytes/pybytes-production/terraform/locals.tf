locals {
  mongodb_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.mongodb_credentials.secret_string
  )
}
