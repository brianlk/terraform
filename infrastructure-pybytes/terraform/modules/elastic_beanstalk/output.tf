output "dns_records" {
  value = {
    cloudflare        = { for k, v in cloudflare_record.public_dns_records : k => v.hostname }
    cloudflare_custom = { for k, v in cloudflare_record.public_dns_records_custom : k => v.hostname }
    route53           = { for k, v in aws_route53_record.private_dns_record : k => v.fqdn }
  }
}

output "eb_environments" {
  value = { for k, v in aws_elastic_beanstalk_environment.this : k => v.name }
}

output "aws_elastic_beanstalk_solution_stack_name" {
  value = data.aws_elastic_beanstalk_solution_stack.node18.name
}