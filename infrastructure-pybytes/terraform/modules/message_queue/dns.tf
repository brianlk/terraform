resource "aws_route53_record" "this" {
  zone_id = var.aws_route53_private_zone_id
  name    = "mq.${var.environment}.${var.tenant}"
  type    = "CNAME"
  ttl     = "1"
  records = [aws_instance.this.private_dns]
}

