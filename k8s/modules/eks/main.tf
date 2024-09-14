locals {
  cluster_security_group_name = "${var.name} EKS cluster security group"
  node_security_group_name    = "${var.name} EKS node shared security group"
}


module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "~> 20.0"
  cluster_name = var.name
  vpc_id       = var.vpc_id
  subnet_ids   = var.public_subnets
  # cluster_version = "1.29"
  create_iam_role = false
  iam_role_arn = "arn:aws:iam::846028654113:role/eksClusterRole"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver     = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

   # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = var.ami_type
    instance_types = [var.instance_type]
    capacity_type  = "ON_DEMAND"
    disk_size      = 30
    key_name       = var.key_pair_name
  }

  eks_managed_node_groups = {
    "${var.name}-nodes" = {
      min_size       = 3
      max_size       = 5
      desired_size   = 3
    }
  }
  cluster_security_group_description = local.cluster_security_group_name
  cluster_security_group_name        = local.cluster_security_group_name
  node_security_group_description    = local.node_security_group_name
  node_security_group_name           = local.node_security_group_name

  tags                               = var.tags
}
