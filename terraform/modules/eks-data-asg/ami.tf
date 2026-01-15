# data "aws_ssm_parameter" "eks_ami_x86" {
#   name = "/aws/service/eks/optimized-ami/${var.cluster_version}/amazon-linux-2/recommended/image_id"
# }

# data "aws_ssm_parameter" "eks_ami_arm" {
#   name = "/aws/service/eks/optimized-ami/${var.cluster_version}/amazon-linux-2-arm64/recommended/image_id"
# }
