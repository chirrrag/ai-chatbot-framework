resource "aws_eks_addon" "addons" {
  # for_each                      = { for addon in var.addons : addon.name => addon }
  cluster_name                  = var.cluster-name
  addon_name                    = var.addon-name
  addon_version                 = var.addon-version
  resolve_conflicts_on_create   = "OVERWRITE"
  resolve_conflicts_on_update   = "OVERWRITE"
  service_account_role_arn      = var.iam-role-arn
  configuration_values          = var.addon-configuration
}