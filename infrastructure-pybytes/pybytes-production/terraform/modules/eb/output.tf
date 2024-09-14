output "dns_records" {
  value = {
    cloudflare_custom = { for k, v in cloudflare_record.public_dns_records_custom : k => v.hostname }
    route53           = { for k, v in aws_route53_record.private_dns_record : k => v.fqdn }
  }
}

output "eb_environments" {
  value = { for k, v in aws_elastic_beanstalk_environment.eb_pybytes : k => v.name }
}
