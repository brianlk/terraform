provider "aws" {
  profile = "default"
  region  = "eu-west-3"
  default_tags {
    tags = {
      created-by  = "terraform",
      source      = "https://github.com/pycom/infrastructure-pybytes",
      Name        = "${var.tenant}-${var.environment}"
      tenant      = var.tenant
      environment = var.environment
    }
  }
}

provider "mongodbatlas" {
  public_key  = local.terraform_credentials.mongodbatlas_public_key
  private_key = local.terraform_credentials.mongodbatlas_private_key
}


provider "aws" {
  profile = "default"
  region  = "eu-central-1"
  alias   = "frankfurt"
}
