resource "aws_s3_bucket" "apps_theme" {
  bucket = "apps-theme-pybytes-production"
}

resource "aws_s3_bucket_acl" "apps_theme_public_read" {
  bucket = aws_s3_bucket.apps_theme.id
  acl    = "public-read"
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
        "Resource" : "arn:aws:s3:::apps-theme-pybytes-production/*"
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
