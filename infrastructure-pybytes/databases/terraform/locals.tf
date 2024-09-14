locals {
  terraform_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.terraform_credentials.secret_string
  )
}
