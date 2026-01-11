module "vpc-addon" {
  source = "../modules/eks-addons"

  addon-name    = "vpc-cni"
  cluster-name  = var.cluster-name
  addon-version = "v1.20.4-eksbuild.1" # 1.32
  # addon-version         = "v1.19.6-eksbuild.1" # 1.31
  iam-role-arn        = ""
  addon-configuration = file("${path.module}/configs/vpc-cni.json")
}

module "kube-proxy-addon" {
  source = "../modules/eks-addons"

  addon-name    = "kube-proxy"
  cluster-name  = var.cluster-name
  addon-version = "v1.32.6-eksbuild.12" # 1.32
  # addon-version         = "v1.31.9-eksbuild.2" # 1.31
  iam-role-arn        = ""
  addon-configuration = file("${path.module}/configs/kube-proxy.json")
}

module "coredns-addon" {
  source = "../modules/eks-addons"

  addon-name    = "coredns"
  cluster-name  = var.cluster-name
  addon-version = "v1.11.4-eksbuild.22" # 1.32
  # addon-version         = "v1.11.4-eksbuild.14" # 1.31
  iam-role-arn        = ""
  addon-configuration = file("${path.module}/configs/core-dns.json")
}

module "ebs-csi-addon" {
  source = "../modules/eks-addons"

  addon-name    = "aws-ebs-csi-driver"
  cluster-name  = var.cluster-name
  addon-version = "v1.50.2-eksbuild.1" # 1.32
  # addon-version         = "v1.45.0-eksbuild.2" # 1.31
  iam-role-arn        = "arn:aws:iam::618305041992:role/prod-aws-ebs-csi-controller-sa"
  addon-configuration = file("${path.module}/configs/ebs-csi.yaml")
}