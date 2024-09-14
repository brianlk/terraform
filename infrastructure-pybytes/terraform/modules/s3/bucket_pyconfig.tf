resource "aws_s3_bucket" "pyconfig" {
  bucket = "pyconfig-${var.tenant}-${var.environment}"
}

resource "aws_s3_bucket_ownership_controls" "pyconfig_acl_ownership" {
  bucket = aws_s3_bucket.pyconfig.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "pyconfig_public_read" {
  bucket                  = aws_s3_bucket.pyconfig.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "pyconfig_public_read" {
  depends_on = [
    aws_s3_bucket_ownership_controls.pyconfig_acl_ownership,
    aws_s3_bucket_public_access_block.pyconfig_public_read,
  ]
  bucket = aws_s3_bucket.pyconfig.id
  acl    = "private"
}
