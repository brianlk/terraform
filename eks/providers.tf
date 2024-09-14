terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }

  }
  required_version = "~> 1.3"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}