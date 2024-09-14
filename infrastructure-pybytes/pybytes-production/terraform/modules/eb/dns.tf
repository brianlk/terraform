resource "cloudflare_record" "public_dns_records_custom" {
  for_each = { for x in var.custom_domain_names : x.id => x }
  name     = each.value["url"]
  value    = aws_elastic_beanstalk_environment.eb_pybytes[each.value["id"]].endpoint_url
  type     = "A"
  zone_id  = var.cloudflare_public_zone_id
}

resource "aws_route53_record" "private_dns_record" {
  for_each = { for x in var.aws_eb_environments : x.id => x }
  name     = "${each.value["id"]}.production.pybytes"
  zone_id  = var.aws_route53_private_zone_id
  type     = "CNAME"
  ttl      = "1"
  records  = [data.aws_instance.eb_environment_ec2_instance[each.value["id"]].private_dns]
}
