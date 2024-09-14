terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      # version = "~> 1.10.2"
    }
  }
}

provider "mongodbatlas" {
  public_key  = ""
  private_key = ""
}
