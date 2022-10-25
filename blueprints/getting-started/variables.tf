# AWS details
variable "aws_region" {
  description = "AWS target region"
  type        = string
  default     = "us-east-1"
}

# EKS cluster name
variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = ""
}

# Sysdig Access Key
variable "sysdig_accesskey" {
  type      = string
  default   = ""
  sensitive = true
}

# Sysdig Collector endpoint url
variable "sysdig_collector_endpoint" {
  type    = string
  default = "collector-static.sysdigcloud.com"
}

# Sysdig NodeAnalyzer endpoint url
variable "sysdig_nodeanalyzer_api_endpoint" {
  type    = string
  default = "secure.sysdig.com"
}
