resource "aws_iam_policy" "bucket_read_write_policy" {
  name   = "${var.bucket_name}-read-write-access"
  policy = data.aws_iam_policy_document.bucket_read_write_policy_document.json
}

data "aws_iam_policy_document" "bucket_read_write_policy_document" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }

  statement {
    effect = "Deny"
    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:PutLifecycleConfiguration",
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}
