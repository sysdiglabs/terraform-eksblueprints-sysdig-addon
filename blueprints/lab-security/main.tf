provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

locals {
  name         = coalesce(var.cluster_name, "${basename(path.cwd)}-${random_string.random_suffix.result}")
  cluster_name = local.name
  region       = var.aws_region

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/sysdiglabs/terraform-eksblueprints-sysdig-addon"
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "aws_availability_zones" "available" {}

################################################################################
# Sysdig Addon
################################################################################

module "sysdig_addon" {
  source = "../../"

  namespace = "sysdig-agent"

  values = [templatefile("${path.module}/values-sysdig.yaml", {
    sysdigAccessKey   = sensitive(var.sysdig_accesskey)
    sysdigRegion      = var.sysdig_region
    sysdigClusterName = local.cluster_name
  })]
}

# Deploy Falco Event Generator
resource "helm_release" "falcoeventgen" {
  chart            = "event-generator"
  name             = "falcosecurity"
  namespace        = var.workloads_namespace
  create_namespace = true
  repository       = "https://falcosecurity.github.io/charts"
  version          = "0.1.1"

  set {
    name  = "podSecurityPolicy.enabled"
    value = false
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  values = [templatefile("${path.module}/values-eventgen.yaml", {
    falcoeventsCommand = "test"
  })]
}

# Deploy Juice-Shop (vulnerable workload)
resource "helm_release" "juiceshop" {
  chart      = "juice-shop"
  name       = "securecodebox"
  namespace  = helm_release.falcoeventgen.metadata[0].namespace
  repository = "https://charts.securecodebox.io"
  version    = "3.15.1"

  values = [templatefile("${path.module}/values-juiceshop.yaml", {
    juiceshopPort = 3000
  })]
}

################################################################################
# EKS Cluster
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name    = local.name
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = ["m5.xlarge"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = local.tags
}

resource "random_string" "random_suffix" {
  length  = 4
  special = false
  upper   = false
}
