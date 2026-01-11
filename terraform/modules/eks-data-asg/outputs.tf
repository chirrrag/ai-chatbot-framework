# output "cluster_version" {
#   description = "The Kubernetes server version for the EKS cluster."
#   value       = element(concat(data.aws_eks_cluster.cluster[*].version, list("")), 0)
# }

# locals {
#   kubeconfig = <<KUBECONFIG
# apiVersion: v1
# clusters:
# - cluster:
#     server: ${data.aws_eks_cluster.cluster.endpoint}
#     certificate-authority-data: ${data.aws_eks_cluster.cluster.certificate_authority[0].data}
#   name: kubernetes
# contexts:
# - context:
#     cluster: kubernetes
#     user: aws
#   name: aws
# current-context: aws
# kind: Config
# preferences: {}
# users:
# - name: aws
#   user:
#     exec:
#       apiVersion: client.authentication.k8s.io/v1alpha1
#       command: aws
#       args:
#         - "eks"
#         - "get-token"
#         - "--cluster-name"
#         - "${var.environment_name}"
#       env: null

# KUBECONFIG

# }

# output "kubeconfig" {
#   value = local.kubeconfig
# }
