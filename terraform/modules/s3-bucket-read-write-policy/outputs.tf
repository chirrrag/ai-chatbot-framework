output "bucket-policy-arn" {
  value = aws_iam_policy.bucket_read_write_policy.arn
}
