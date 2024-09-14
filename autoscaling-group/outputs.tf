output "application_endpoint" {
  value = "http://${aws_lb.terramino.dns_name}/"
}

output "auto_scaling_group_name" {
  value = aws_autoscaling_group.terramino.name
}

# output "rds_name" {
#   value = aws_db_instance.terramino_db.identifier
# }

