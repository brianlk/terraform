resource "aws_s3_bucket" "pyconfig" {
  bucket = "pyconfig-pybytes-production"
}

resource "aws_s3_bucket_acl" "pyconfig_public_read" {
  bucket = aws_s3_bucket.pyconfig.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "pyconfig_public_read" {
  bucket                  = aws_s3_bucket.pyconfig.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}