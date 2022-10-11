# Helm addon
module "helm_addon" {
  #Change before publishing
  source               = "github.com/manuelbcd/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.1.0"
  #source               = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.1.0"
  #
  manage_via_gitops    = var.manage_via_gitops
  # TODO cook set_values and set_sensitive_values to register the endpoints, ports and tokens
  # set_values           = local.set_values
  # set_sensitive_values = local.set_sensitive_values
  helm_config          = local.helm_config
  addon_context        = var.addon_context
}