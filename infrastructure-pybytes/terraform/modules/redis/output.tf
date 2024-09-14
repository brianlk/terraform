output "connection_info" {
  description = "Redis access information"
  value = {
    private_cname = aws_route53_record.this.fqdn
    public_cname  = cloudflare_record.this.hostname
  }
}


