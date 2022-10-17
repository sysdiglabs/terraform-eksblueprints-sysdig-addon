provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
    }
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

data "aws_availability_zones" "available" {}

locals {
  name = basename(path.cwd)
  # var.cluster_name is for Terratest
  cluster_name = coalesce(var.cluster_name, local.name)
  region       = var.aws_region

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint  = local.name
    # Change before publishing
    #GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
    GithubRepo = "github.com/manuelbcd/terraform-aws-eks-blueprints"
  }
}

#---------------------------------------------------------------
# EKS Blueprints
#---------------------------------------------------------------

module "eks_blueprints" {
  # Change before publishing
  #source = "github.com/aws-ia/terraform-aws-eks-blueprints"
  source = "github.com/manuelbcd/terraform-aws-eks-blueprints"

  cluster_name    = local.cluster_name
  cluster_version = "1.23"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    mg_5 = {
      node_group_name = "managed-ondemand"
      instance_types  = ["m5.large"]
      min_size        = 2
      subnet_ids      = module.vpc.private_subnets
    }
  }

  tags = local.tags
}

module "eks_blueprints_kubernetes_addons" {

  #TODO Change before publishing
  #source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"
  source = "github.com/manuelbcd/terraform-aws-eks-blueprints//modules/kubernetes-addons"

  eks_cluster_id       = module.eks_blueprints.eks_cluster_id
  eks_cluster_endpoint = module.eks_blueprints.eks_cluster_endpoint
  eks_oidc_provider    = module.eks_blueprints.oidc_provider
  eks_cluster_version  = module.eks_blueprints.eks_cluster_version

  # EKS Managed Add-ons
  enable_amazon_eks_vpc_cni            = true
  enable_amazon_eks_coredns            = true
  enable_amazon_eks_kube_proxy         = true

  # Add-ons
  enable_metrics_server               = true
  enable_cluster_autoscaler           = true

  # Sysdig addon
  enable_sysdig_agent                 = true

  sysdig_agent_helm_config            = {
    set_sensitive = [
      {
        name  = "sysdig-accesskey"
        value = var.sysdig-accesskey
      },
      {
        name  = "sysdig-collector-endpoint"
        value = var.sysdig-collector-endpoint
      },
      {
        name  = "sysdig-nodeanalyzer-api-endpoint"
        value = var.sysdig-nodeanalyzer-api-endpoint
      }      
    ]
  }

  enable_cert_manager = true
  cert_manager_helm_config = {
    set_values = [
      {
        name  = "extraArgs[0]"
        value = "--enable-certificate-owner-ref=false"
      },
    ]
  }

  tags = local.tags
}

#---------------------------------------------------------------
# Supporting Resources
#---------------------------------------------------------------

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

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