provider "aws" {
  region                  = "ap-south-1"
  version                 = "5.0.0"
  shared_credentials_files = ["~/.aws/credentials"]
}

data "aws_eks_cluster" "prod" {
  name = "prod"
}

data "aws_eks_cluster_auth" "prod" {
  name = "prod"
}

provider "helm" {
  version = "2.10.1"
  debug   = true
  alias   = "prod"

  kubernetes {
    host                   = data.aws_eks_cluster.prod.endpoint
    token                  = data.aws_eks_cluster_auth.prod.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.prod.certificate_authority.0.data)
  }
}

terraform {
  backend "s3" {
    region         = "ap-south-1"
    bucket         = "ft-infra"
    key            = "terraform/resources/helm/prod/terraform.tfstate"
    dynamodb_table = "ft-infra-terraform"
    encrypt        = true
  }
}
