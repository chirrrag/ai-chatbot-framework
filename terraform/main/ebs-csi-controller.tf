data "aws_iam_openid_connect_provider" "prod_eks_oidc_provider" {
  arn = "arn:aws:iam::618305041992:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/B89A2232B2CCFF60CC667572877D479F"
}

data "aws_iam_policy_document" "prod_ebs_csi_driver_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.prod_eks_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.prod_eks_oidc_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "prod_ebs_csi_driver_role" {
  assume_role_policy = data.aws_iam_policy_document.prod_ebs_csi_driver_policy.json
  name               = "prod-aws-ebs-csi-controller-sa"
}

resource "aws_iam_policy" "prod_aws_ebs_csi_driver_policy" {
  name   = "prod-ebs-csi-controller-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:ModifyVolume",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeSnapshots",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumesModifications",
                "ec2:DeleteVolume"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": "arn:aws:ec2:*:*:volume/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Resource": "arn:aws:ec2:*:*:snapshot/*"
        }
    ]
}
 EOF
}

resource "aws_iam_role_policy_attachment" "prod_aws_ebs_csi_driver_policy_attachement" {
  policy_arn = resource.aws_iam_policy.prod_aws_ebs_csi_driver_policy.arn
  role       = aws_iam_role.prod_ebs_csi_driver_role.name
}