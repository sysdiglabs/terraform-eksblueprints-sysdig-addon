# Helm addon
module "helm_addon" {
  #Change before publishing
  source               = "github.com/manuelbcd/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.12.2"
  #source               = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v4.1.0"
  
  addon_context = var.addon_context
  helm_config   = local.helm_config
}