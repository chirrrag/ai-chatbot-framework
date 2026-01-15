resource "aws_eks_cluster" "ft-prod" {
  name     = "prod"
  role_arn = "arn:aws:iam::618305041992:role/prod-eks"
  version  = var.cluster-version

  vpc_config {
    endpoint_private_access = "true"
    endpoint_public_access  = "false"
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = ["sg-051f7473b9c424436"]
    subnet_ids              = ["subnet-0e004ee8576a7be24", "subnet-0265fa4284db98cf3"]
  }

  enabled_cluster_log_types = ["api", "controllerManager", "scheduler", ]

  tags = {
    "Env"     = "prod"
    "Name"    = "prod"
    "Service" = "eks"
    "Team"    = "k8s"
    "product" = "shared"
  }
}