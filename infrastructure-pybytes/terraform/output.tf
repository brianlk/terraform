output "redis" {
  description = "Redis access information"
  value       = module.redis.connection_info
}

output "eb_dns_records" {
  value = module.elastic_beanstalk.dns_records
}

output "message_queue" {
  value = {
    route53   = module.message_queue.connection_info.private_cname
    public_ip = module.message_queue.message_queue_public_ip
  }
}

output "aws" {
  value = {
    vpc_id              = module.networking.aws_vpc_id
    vpc_route_table_id  = module.networking.aws_vpc_route_table_id
    private_subnet_1    = module.networking.private_subnet_1
    private_subnet_2    = module.networking.private_subnet_2
    ec2_security_group  = module.security.aws_sg_allow_internal_traffic
    aws_iam_role_arn    = module.security.aws_iam_role_arn_pybytes_app
    solution_stack_name = module.elastic_beanstalk.aws_elastic_beanstalk_solution_stack_name
    eb_env_names        = module.elastic_beanstalk.eb_environments
    s3_buckets_url      = module.s3.buckets_url
    s3_buckets_name     = module.s3.buckets_name
  }
}
