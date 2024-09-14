output "eb_env_names" {
  value = module.elastic_beanstalk.eb_environments
}


output "eb_dns_records" {
  value = module.elastic_beanstalk.dns_records
}

output "s3_buckets_details" {
  value = {
    buckets_url  = module.s3.buckets_url
    buckets_name = module.s3.buckets_name
  }
}
