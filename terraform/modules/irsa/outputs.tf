output "role_arn" {
  value       = aws_iam_role.irsa_role.arn
  description = "The ARN of the role"
}

output "role_name" {
  value       = aws_iam_role.irsa_role.name
  description = "The name of the role"
}

output "policy_name" {
  value       = aws_iam_policy.workload_policy.name
  description = "The name of the policy"
}
