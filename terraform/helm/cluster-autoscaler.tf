resource "helm_release" "cluster-autoscaler" {
  provider   = helm.prod
  name       = "prod"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.28.0"
  namespace  = "kube-system"

  values = ["${file("cluster-autoscaler-values.yaml")}"]
}
