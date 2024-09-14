output "aws_iam_instance_profile_name_pybytes_app" {
  value = aws_iam_instance_profile.pybytes_app.name
}

output "aws_iam_role_arn_pybytes_app" {
  value       = aws_iam_role.pybytes_app.arn
  description = "arn of iam app role"
}

output "aws_iam_role_name_pybytes_app" {
  value       = aws_iam_role.pybytes_app.name
  description = "name of iam app role"
}

output "aws_sg_allow_https_from_internet_id" {
  value = aws_security_group.allow_https_from_internet.id
}

output "aws_sg_allow_ssh_from_pycom" {
  value = aws_security_group.allow_ssh_from_pycom.id
}

output "aws_sg_allow_internet_access" {
  value = aws_security_group.allow_internet_access.id
}

output "aws_sg_allow_mqtt_from_internet" {
  value = aws_security_group.allow_mqtt_from_internet.id
}

output "aws_sg_allow_internal_traffic" {
  value = aws_security_group.allow_internal_traffic.id
}

output "aws_key_pair_deployer" {
  value = aws_key_pair.deployer.key_name
}
