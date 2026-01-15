resource "helm_release" "alb-controller" {
  provider   = helm.prod
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.0"
  namespace  = "kube-system"
  values =  [ "${file("alb-controller-values.yaml")}" ]
}