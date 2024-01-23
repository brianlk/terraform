terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }

  required_version = ">= 0.15"
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      hashicorp-learn = "aws-asg"
    }
  }
}
