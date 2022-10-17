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

variable "sysdig-accesskey" {
  type    = string
  default = ""
  sensitive = true
}

variable "sysdig-collector-endpoint" {
  type    = string
  default = "collector-static.sysdigcloud.com"
  sensitive = true
}

variable "sysdig-nodeanalyzer-api-endpoint" {
  type    = string
  default = "secure.sysdig.com"
  sensitive = true
}