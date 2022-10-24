resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

locals {
  name        = "sysdig"
  namespace   = "sysdig"

  set_values = []

  default_helm_config = {
    name             = local.name
    chart            = "sysdig-deploy"
    repository       = "https://charts.sysdig.com"
    version          = "1.3.28"
    namespace        = local.namespace
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

  default_helm_values = [templatefile("${path.module}/values.yaml", {},)]

}