resource "helm_release" "this" {
  name             = "sysdig"
  chart            = "sysdig-deploy"
  repository       = "https://charts.sysdig.com"
  version          = var.chart_version
  description      = var.description
  namespace        = var.namespace
  create_namespace = var.create_namespace
  values           = var.values

  dynamic "set" {
    for_each = var.set

    content {
      name  = set.value.name
      value = set.value.value
      type  = try(set.value.type, null)
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = try(set_sensitive.value.type, null)
    }
  }

  wait = false
}
