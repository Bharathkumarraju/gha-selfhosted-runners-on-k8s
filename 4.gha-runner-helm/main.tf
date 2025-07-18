
provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = local.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(local.eks_cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", local.eks_cluster_name]
  }
}

provider "helm" { 
  kubernetes = {
    host                   = local.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(local.eks_cluster_ca_certificate)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", local.eks_cluster_name]
    }
  }
}

resource "kubernetes_namespace_v1" "actions" {
  metadata {
    name = "actions"
  }
}


resource "kubernetes_secret_v1" "github_runner_config" {
  metadata {
    name      = "github-config"
    namespace = kubernetes_namespace_v1.actions.metadata[0].name
  }

  data = {
    github_app_id              = local.github_app_id
    github_app_installation_id = local.github_app_installation_id
    github_app_private_key     = data.aws_ssm_parameter.github_privatekey.value
  }
}

# arc = actions runner controller
resource "helm_release" "arc_systems" {
  name       = "arc-systems"
  namespace  = kubernetes_namespace_v1.actions.metadata[0].name
  chart      = "gha-runner-scale-set-controller"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  version    = "0.12.1"
}

resource "helm_release" "arc_runners" {
  name       = "gha-runner"
  namespace  = kubernetes_namespace_v1.actions.metadata[0].name
  chart      = "gha-runner-scale-set"
  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  version    = "0.12.1"

  values = [
    yamlencode({
      githubConfigUrl    = "https://github.com/1dot618labs"
      githubConfigSecret = kubernetes_secret_v1.github_runner_config.metadata[0].name
    })
  ]

  depends_on = [
    helm_release.arc_systems
  ]
}