output "buckets_url" {
  value = {
    apps_theme = aws_s3_bucket.apps_theme.bucket_domain_name
  }
}

output "buckets_name" {
  value = {
    apps_config = aws_s3_bucket.apps_config.id
    apps_theme  = aws_s3_bucket.apps_theme.id
    pyconfig    = aws_s3_bucket.pyconfig.id
  }
}
