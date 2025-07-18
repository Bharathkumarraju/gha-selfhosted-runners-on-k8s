data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_availability_zones" "all" {
  state = "available"
}



data "terraform_remote_state" "aws-vpc" {
  backend = "s3"
  config = {
    bucket = "tfm-state-store-bkr20250717234017323200000001"
    key    = "tfstate/gha/vpc"
    region = "ap-south-1"
  }
}


data "terraform_remote_state" "aws-eks" {
  backend = "s3"
  config = {
    bucket = "tfm-state-store-bkr20250717234017323200000001"
    key    = "tfstate/gha/eks"
    region = "ap-south-1"
  }
}

