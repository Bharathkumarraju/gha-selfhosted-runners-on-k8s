data "aws_eks_cluster_auth" "cluster_auth" {
  name = local.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = local.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(local.eks_cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
  }

}

provider "kubernetes" {
  host                   = local.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(local.eks_cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}


resource "kubernetes_namespace_v1" "actions" {
  metadata {
    name = "actions"
  }
}