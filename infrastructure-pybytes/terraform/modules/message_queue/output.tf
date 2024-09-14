
output "connection_info" {
  description = "Message Queue access information"
  value = {
    private_cname = aws_route53_record.this.fqdn
  }
}

output "message_queue_public_ip" {
  value       = aws_instance.this.public_ip
  description = "The public IP of the RabbitMQ instance"
}
