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