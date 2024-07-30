# vpc

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.cidr_vpc

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet
  public_subnets  = var.public_subnet


  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

 tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"      = 1
  }

}

#eks

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.24"
  
  cluster_endpoint_public_access = true


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    nodes = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      #   ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  #   # Cluster access entry
  #   # To add the current caller identity as an administrator
  #   enable_cluster_creator_admin_permissions = true

  #   access_entries = {
  #     # One access entry with a policy associated
  #     example = {
  #       kubernetes_groups = []
  #       principal_arn     = "arn:aws:iam::123456789012:role/something"

  #       policy_associations = {
  #         example = {
  #           policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  #           access_scope = {
  #             namespaces = ["default"]
  #             type       = "namespace"
  #           }
  #         }
  #       }
  #     }
  #   }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
