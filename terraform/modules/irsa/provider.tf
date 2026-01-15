provider "kubernetes" {
  version                = "~>1.13.2"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster
}
