locals {
  name = "sysdig-agent"

  default_helm_config = {
    name             = "sysdig-agent"
    namespace        = "sysdig-agent"
    chart            = "sysdig-deploy"
    repository       = "https://charts.sysdig.com"
    version          = "1.3.12"
    namespace        = local.name
    create_namespace = true
    values           = local.default_helm_values
    set              = []
    description      = "Sysdig HelmChart Sysdig-Deploy configuration"
    wait             = false
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  default_helm_values = [templatefile("${path.module}/sysdig_helm_values.yml", {
    sysdig_accesskey                  = "prueba"
    sysdig_collector_endpoint         = ""
    sysdig_nodeanalyzer_api_endpoint  = ""
    },
  )]

  argocd_gitops_config = {
    enable = true
  }
}