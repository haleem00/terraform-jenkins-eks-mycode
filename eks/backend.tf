terraform {
  backend "s3" {
    bucket = "kube-vpro1"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}