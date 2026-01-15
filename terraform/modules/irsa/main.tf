locals {
  oidc = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
}

resource "aws_iam_role" "irsa_role" {
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc}"
      },
      "Condition": {
        "StringEquals": {
          "${local.oidc}:sub": "system:serviceaccount:${var.namespace}:${var.service_account}"
        }
      }
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "workload_policy" {
  name   = var.policy_name
  policy = var.policy_doc
}

resource "aws_iam_role_policy_attachment" "workload-role-policy" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = aws_iam_policy.workload_policy.arn
}

resource "kubernetes_service_account" "app-sa" {
  metadata {
    name      = var.service_account
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_role.arn
    }
  }
  // Required
  automount_service_account_token = true
}
