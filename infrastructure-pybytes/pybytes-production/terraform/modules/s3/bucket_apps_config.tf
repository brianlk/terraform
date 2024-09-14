resource "aws_s3_bucket" "apps_config" {
  bucket = "apps-config-pybytes-production"
}

resource "aws_s3_bucket_acl" "apps_config_public_read" {
  bucket = aws_s3_bucket.apps_config.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "apps_config_public_read" {
  bucket                  = aws_s3_bucket.apps_config.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
