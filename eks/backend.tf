terraform {
  backend "s3" {
    bucket = "kube-vpro1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}