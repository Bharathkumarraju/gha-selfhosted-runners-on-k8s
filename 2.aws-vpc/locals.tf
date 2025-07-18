locals {
  name   = "bharaths-eks"
  region = "ap-south-1"

  vpc_cidr = "10.1.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    env  = "dev"
    purpose  = "demo"
  }
}

