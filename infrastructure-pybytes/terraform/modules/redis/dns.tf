resource "aws_route53_record" "this" {
  zone_id = var.aws_route53_private_zone_id
  name    = "redis.${var.environment}.${var.tenant}"
  type    = "CNAME"
  ttl     = "1"
  records = [aws_instance.this.private_dns]
}

resource "cloudflare_record" "this" {
  name    = "redis.${var.environment}.${var.tenant}"
  value   = aws_instance.this.public_dns
  type    = "CNAME"
  zone_id = var.cloudflare_public_zone_id
}
