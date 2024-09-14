resource "aws_route53_zone_association" "vpc_to_pycom_awsprivate_zone" {
  zone_id = var.aws_route53_private_zone_id
  vpc_id  = aws_vpc.this.id
}
