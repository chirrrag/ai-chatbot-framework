resource "aws_iam_group" "app-group" {
  name = var.group_name
  path = "/"
}

resource "aws_iam_group_policy_attachment" "app-group-policy-attachment" {
  group      = aws_iam_group.app-group.name
  policy_arn = var.iam_policy_arn
}

variable "iam_policy_arn" {}
variable "group_name" {}
