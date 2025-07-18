locals {
  name   = "bharaths-eks"
  region = "ap-south-1"

  tags = {
    env  = "dev"
    purpose  = "demo"
  }

  eks_cluster_name = data.terraform_remote_state.aws-eks.outputs.cluster_name
  eks_cluster_ca_certificate =  data.terraform_remote_state.aws-eks.outputs.cluster_certificate_authority_data
  eks_cluster_endpoint = data.terraform_remote_state.aws-eks.outputs.cluster_endpoint

  github_app_id = "1619953"
  github_app_installation_id = "76260063"
}

