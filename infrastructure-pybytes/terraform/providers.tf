provider "aws" {
  profile = "default"
  region  = var.aws_application_region_name
  default_tags {
    tags = {
      created-by  = "terraform",
      source      = "https://github.com/pycom/pybytes-script",
      Name        = "${var.tenant}-${var.environment}"
      tenant      = var.tenant
      environment = var.environment
      # monitored   = 1
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
  alias   = "frankfurt"
}
