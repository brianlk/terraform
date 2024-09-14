resource "aws_s3_bucket" "apps_config" {
  bucket = "apps-config-${var.tenant}-${var.environment}"
}

resource "aws_s3_bucket_ownership_controls" "apps_config_acl_ownership" {
  bucket = aws_s3_bucket.apps_config.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "apps_config_public_read" {
  depends_on = [aws_s3_bucket_ownership_controls.apps_config_acl_ownership]
  bucket     = aws_s3_bucket.apps_config.id
  acl        = "private"
}

resource "aws_s3_bucket_public_access_block" "apps_config_public_read" {
  bucket                  = aws_s3_bucket.apps_config.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

