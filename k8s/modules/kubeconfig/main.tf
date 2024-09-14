# Write kubeconfig to  ~/.kube/config
resource "local_file" "kubeconfig" {
  content = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${var.eks.ca_data}
    server: ${var.eks.endpoint}
  name: ${var.eks.arn}
contexts:
- context:
    cluster: ${var.eks.arn}
    user: ${var.eks.arn}
  name: ${var.eks.arn}
current-context: ${var.eks.arn}
kind: Config
preferences: {}
users:
- name: ${var.eks.arn}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - ${var.region}
      - eks
      - get-token
      - --cluster-name
      - ${var.eks.name}
      command: aws --profile test-eks-role
EOT
  filename = "${var.kubeconfig_folder}/config-${var.eks.name}"
}