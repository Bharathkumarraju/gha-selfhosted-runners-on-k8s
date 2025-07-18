module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.name
  cluster_version = "1.33"

  bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true


  vpc_id                   = data.terraform_remote_state.aws-vpc.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.aws-vpc.outputs.public_subnets
  control_plane_subnet_ids = data.terraform_remote_state.aws-vpc.outputs.public_subnets

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium", "t3.small"]
  }

  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }

  tags = local.tags
}
