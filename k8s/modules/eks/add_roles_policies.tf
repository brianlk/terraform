# Create a role for EBS provision
module "ebs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "${var.name}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers        = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
  tags = var.tags
}

# Create a role for S3 access
module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "${var.name}-ctrl-aws-access-role"

  # role_policy_arns = {
  #   policy = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  #   policy = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  # }

  oidc_providers = {
    one = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:ctrl-aws-access-sa"]
    }
    # two = {
    #   provider_arn               = "arn:aws:iam::012345678901:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/5C54DDF35ER54476848E7333374FF09G"
    #   namespace_service_accounts = ["default:my-app-staging"]
    # }
  }
  tags = var.tags
}

data "aws_iam_policy" "ctrl_access_aws_policy" {
  for_each = toset(["AmazonS3FullAccess"])
  name     = each.value
}

# Attach the policies to the role
resource "aws_iam_role_policy_attachment" "ctrl_access_aws_policy_attachment" {
  for_each   = data.aws_iam_policy.ctrl_access_aws_policy
  role       = module.iam_eks_role.iam_role_name
  policy_arn = each.value.arn
}