terraform {
  backend "s3" {
    bucket = "tfm-state-store-bkr20250717234017323200000001"
    key = "tfstate/gha/network"
    region = "ap-south-1"
    use_lockfile = true
  }
}