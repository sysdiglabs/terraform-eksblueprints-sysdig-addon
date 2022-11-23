# Getting Started Sysdig Terraform Blueprint for EKS

## Introduction

[Sysdig](https://sysdig.com) is a security and monitor platform built for you to confidently run cloud and containers. 
This Getting Started Blueprint allows to deploy AWS EKS clusters with a built in [Sysdig Addon](https://registry.terraform.io/modules/sysdiglabs/sysdig-addon/eksblueprints/latest) from the day zero. It also makes it easy to customize and extend the blueprint following a gitops approach to adapt it to your needs regarding to [security](https://sysdig.com/products/secure/), [monitoring](https://sysdig.com/products/monitor/) or both secure and monitor with [Sysdig Platform Architecture](https://sysdig.com/platform-architecture/).

This blueprint will generate the following components: 

* 1x VPC with private and public subnets
* 1x EKS Cluster
* 1x Managed node group for EKS
* Sysdig instrumentation as Daemonset via Helm on the cluster


## Prerequisites

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [AWS-Cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
* A [Sysdig account](https://sysdig.com/company/start-free/). You can register your [Sysdig Trial](https://sysdig.com/company/start-free/) for a free evaluation period.

## Usage

1. Clone this repository and get into the blueprint folder

    ````
    git clone https://github.com/sysdiglabs/terraform-eksblueprints-sysdig-addon.git

    cd blueprints/getting-started
    ````

2. Initialize by providing the proper credentials and region from your Sysdig SaaS account.
https://docs.sysdig.com/en/docs/administration/saas-regions-and-ip-ranges   
You can choose between to ways to pass the parameters:

    **a. Initialize values using terraform.tfvars**  
    Rename the *terraform.tfvars.backup* file to *terraform.tfvars* and populate the values.
    ```
    sysdig_accesskey="fa3efa3e-1234-1234-1234-fa3efa3e8120a"
    sysdig_region="us2"

    cluster_name="DevClusterB"
    aws_region="us-west-1"
    ```
    **b. Initialize using system variables (TF_VARS)**  
    (You can optionally indicate a cluster name and AWS region).
    ```
    export TF_VAR_sysdig_accesskey=fa3efa3e-1234-1234-1234-fa3efa3e8120a
    export TF_VAR_sysdig_regiont=us1
    export TF_VAR_cluster_name="my-aws-cluster-sysdig"
    export TF_VAR_aws_region="sa-east-1"
    ```
1. Initialize, plan the execution and then apply

    ```
    terraform init
    terraform plan
    terraform apply
    ```
2. Once the Terraform the process gets finished we can configure our local kubeconfig with the following aws-cli command. ( *\<aws-region\> and \<cluster-name\> has to be copied from the previous output or reuse the cluster_name and aws_region parameters if they were declared before* )
    ```
    aws eks --region <aws-region> update-kubeconfig --name <cluster-name>
    ```
3. Our EKS cluster is ready to be operated, we can check the runnning pods
    ```
    kubectl get nodes --all-namespaces
    ```
4. Go to the Sysdig UI : Integrations > Data Sources. The new cluster as well as its nodes should appear in the list.

## Customize the blueprint

## Extend or change the EKS cluster
Modify the following module from main.tf

```
module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints"

  cluster_name    = local.cluster_name
  cluster_version = "1.23"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    mg_5 = {
      node_group_name = "managed-ondemand"

      instance_types = ["m5.large"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 50

      desired_size    = 3
      max_size        = 3
      min_size        = 2
      max_unavailable = 1

      subnet_ids = module.vpc.private_subnets
    }
  }

  ...
  
  tags = local.tags
}
```


### Extend or change addons and Sysdig instrumentation

Modify the following module from main.tf

```
module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"

  ...

  # Sysdig addon
  enable_sysdig_agent = true

  sysdig_agent_helm_config = {

    namespace = "sysdig-agent"

    values = [templatefile("${path.module}/values.yaml", {
      sysdigAccessKey         = sensitive(var.sysdig_accesskey)
      sysdigCollectorEndpoint = var.sysdig_collector_endpoint
      sysdigNodeAnalyzer      = var.sysdig_nodeanalyzer_api_endpoint
      sysdigClusterName       = local.cluster_name
    })]
  }

  tags = local.tags
}
```
To find out all the parameters accepted by the sysdig_agent EKS Terraform plugin please check the official (sysdig-deploy helm chart documentation)[https://charts.sysdig.com/charts/sysdig-deploy/].



<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS target region | `string` | `"us-east-1"` | no |
| cluster_name | Cluster name | `string` | `""` | no |
| sysdig_accesskey | Sysdig Access Key | `string` | `""` | no |
| sysdig_region | us1\|us2\|us3\|us4\|eu1\|au1\|custom https://docs.sysdig.com/en/docs/administration/saas-regions-and-ip-ranges/ | `string` | `"us2"` | no |

### Outputs

| Name | Description |
|------|-------------|
| configure_kubectl | Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig |
| eks_cluster_id | EKS cluster ID |
| eks_managed_nodegroup_arns | EKS managed node group arns |
| eks_managed_nodegroup_ids | EKS managed node group ids |
| eks_managed_nodegroup_role_name | EKS managed node group role name |
| eks_managed_nodegroup_status | EKS managed node group status |
| eks_managed_nodegroups | EKS managed node groups |
| region | AWS region |
| vpc_cidr | VPC CIDR |
| vpc_private_subnet_cidr | VPC private subnet CIDR |
| vpc_public_subnet_cidr | VPC public subnet CIDR |
<!-- END_TF_DOCS -->