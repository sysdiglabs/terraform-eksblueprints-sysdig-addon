# AWS details
variable "aws_region" {
  description = "AWS target region"
  type        = string
  default     = "sa-east-1"
}

# AWS Cluster name
variable "cluster_name" {
  description = "Name of cluster"
  type        = string
  default     = ""
}

variable "sysdig_accesskey" {
  type    = string
  default = ""
  sensitive = true
}

variable "sysdig_collector_endpoint" {
  type    = string
  default = "collector-static.sysdigcloud.com"
}

variable "sysdig_nodeanalyzer_api_endpoint" {
  type    = string
  default = "secure.sysdig.com"
}