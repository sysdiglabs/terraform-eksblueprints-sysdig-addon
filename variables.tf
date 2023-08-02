variable "chart_version" {
  description = "The version of the Sysdig Helm Chart to deploy"
  type        = string
  default     = "1.17.0"
}

variable "description" {
  description = "The description of the Sysdig Helm Chart to deploy"
  type        = string
  default     = "Sysdig agent Helm chart"
}

variable "namespace" {
  description = "The namespace to deploy the Sysdig Helm Chart into"
  type        = string
  default     = "sysdig"
}

variable "create_namespace" {
  description = "Whether to create the namespace to deploy the Sysdig Helm Chart into"
  type        = bool
  default     = true
}

variable "values" {
  description = "The values to pass to the Sysdig Helm Chart"
  type        = list(string)
  default = [
    <<-EOT
        global:
          kspm:
            deploy: true
        ebpf:
            enabled: false
        nodeAnalyzer:
          nodeAnalyzer:
            benchmarkRunner:
              deploy: false
            runtimeScanner:
              settings:
                eveEnabled: true
          secure:
            vulnerabilityManagement:
              newEngineOnly: true
      EOT
  ]
}

variable "set" {
  description = "Value block with custom values to be merged with the values yaml"
  type        = any
  default     = []
}

variable "set_sensitive" {
  description = "Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff"
  type        = any
  default     = []
}
