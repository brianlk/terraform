resource "aws_s3_bucket" "apps_theme" {
  bucket = "apps-theme-${var.tenant}-${var.environment}"
}

resource "aws_s3_bucket_ownership_controls" "apps_theme_acl_ownership" {
  bucket = aws_s3_bucket.apps_theme.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "apps_theme_public_read" {
  bucket                  = aws_s3_bucket.apps_theme.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "apps_theme_allow_public_access" {
  bucket = aws_s3_bucket.apps_theme.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::apps-theme-${var.tenant}-${var.environment}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "apps_theme_allow_frontend" {
  bucket = aws_s3_bucket.apps_theme.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}
