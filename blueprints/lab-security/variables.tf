# AWS details
variable "aws_region" {
  description = "AWS target region"
  type        = string
  default     = "us-east-1"
}

# EKS Cluster name
# tflint-ignore: terraform_unused_declarations
variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = ""
}

# Sysdig Access Key
variable "sysdig_accesskey" {
  description = "Sysdig agent access Key (Integrations > Agent Installation > Your access key )"
  type        = string
  default     = ""
  sensitive   = true
}

# us1|us2|us3|us4|eu1|au1|custom
# https://docs.sysdig.com/en/docs/administration/saas-regions-and-ip-ranges/
variable "sysdig_region" {
  description = "Sysdig SaaS region (us1|us2|us3|us4|eu1|au1|custom)"
  type        = string
  default     = "us2"
}

# Namespace for the test workloads
variable "namespace" {
  description = "Namespace for the test workloads"
  type        = string
  default     = ""
}
