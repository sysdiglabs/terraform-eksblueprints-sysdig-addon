# Helm addon
module "helm_addon" {
  #Change before publishing
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.17.0"

  addon_context = var.addon_context
  set_values    = local.set_values
  helm_config   = local.helm_config
}
