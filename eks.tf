##############################
# EKS Cluster with Pod Identity
##############################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  # VPC config
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  # Use private subnets for control plane
  control_plane_subnet_ids = module.vpc.private_subnets

  
  cluster_endpoint_public_access  = true

  # Disable default AWS-managed add-ons (CoreDNS, kube-proxy, VPC CNI)
  cluster_addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {}
    # Enable Pod Identity Agent (replaces IRSA)
    eks-pod-identity-agent =true
  }

  ########################
  # Managed Node Group
  ########################
  eks_managed_node_groups = {
    eks_nodes = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size    = 20

    }
  }

  ########################
  # Cluster Settings
  ########################

  cluster_enabled_log_types = ["api", "audit", "authenticator"]
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  
  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }
  enable_irsa = true

  # Tags for identification
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}