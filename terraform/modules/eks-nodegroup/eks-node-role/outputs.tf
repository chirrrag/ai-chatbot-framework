output "eks-role-name" {
  value = "${aws_iam_role.node.name}"
}
