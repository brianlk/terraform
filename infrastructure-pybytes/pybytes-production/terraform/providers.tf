provider "aws" {
  profile = "default"
  region  = "eu-central-1"
  default_tags {
    tags = {
      created-by  = "terraform",
      source      = "https://github.com/pycom/git@github.com:pycom/infrastructure-pybytes",
      Name        = "pybytes-production"
      tenant      = "pybytes"
      environment = "production"
    }
  }
}

provider "mongodbatlas" {
  public_key  = local.mongodb_credentials.mongodbatlas_public_key
  private_key = local.mongodb_credentials.mongodbatlas_private_key
}
