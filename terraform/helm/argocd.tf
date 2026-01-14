resource "helm_release" "argocd" {
  provider   = helm.prod
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.2.0"
  namespace  = "argocd"

  values = ["${file("argocd-values.yaml")}"]
}

