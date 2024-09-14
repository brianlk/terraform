output "ca_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "endpoint" {
  value = module.eks.cluster_endpoint
}

output "name" {
  value = module.eks.cluster_name
}

output "arn" {
  value = module.eks.cluster_arn
}

output "cluster_sg_id" {
  value = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "app_iam_role_arn" {
  value = module.iam_eks_role.iam_role_arn
}