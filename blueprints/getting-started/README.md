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
* A [Sysdig account](https://sysdig.com/company/start-free/). You can register your [Sysdig Trial]https://sysdig.com/company/start-free/] for a free evaluation period.

## Usage

1. Clone this repository and get into the blueprint folder

    ````
    git clone https://github.com/sysdiglabs/terraform-eksblueprints-sysdig-addon.git

    cd blueprints/getting-started
    ````

2. Initialize TF VARS with the proper credentials and urls from your Sysdig SaaS account and region.
https://docs.sysdig.com/en/docs/administration/saas-regions-and-ip-ranges   
You can optionally indicate a cluster name and AWS region.

    ```
    export TF_VAR_sysdig_accesskey=<sysdig-agent-accesskey>
    export TF_VAR_sysdig_collector_endpoint=<sysdig_collector_endpoint>
    export TF_VAR_nodeanalyzer-api-endpoint=<sysdig_nodeanalyzer_api_endpoint>
    export TF_VAR_cluster_name=<cluster_name>   # Optional
    export TF_VAR_aws_region=<aws-region>       # Optional
    ```

    Example using a Sysdig account from us-west (us2) monitoring an EKS cluster located in the AWS region of Sao Paolo (sa-east-1)
    ```
    export TF_VAR_sysdig_accesskey=fa3efa3e-95ee-4233-b222-fa3efa3e8120a
    export TF_VAR_sysdig_collector_endpoint=ingest-us2.app.sysdig.com
    export TF_VAR_nodeanalyzer-api-endpoint=us2.app.sysdig.com
    export TF_VAR_cluster_name="my-aws-cluster-sysdig"
    export TF_VAR_aws_region="sa-east-1"
    ```
3. Initialize, plan the execution and then apply

    ```
    terraform init
    terraform plan
    terraform apply
    ```
4. Once the Terraform the process gets finished we can configure our local kubeconfig with the following aws-cli command. (\\<aws-region\\> and \\<cluster-name\\> has to be copied from the previous output or use $TF_VAR_cluster_name and $TF_VAR_aws_region if they was declared before)
    ```
    aws eks --region <aws-region> update-kubeconfig --name <cluster-name>
    ```
5. Our EKS cluster is ready to be operated, we can check the runnning pods
    ```
    kubectl get nodes --all-namespaces
    ```
6. Go to the Sysdig UI : Integrations > Data Sources. The new cluster as well as its nodes should appear in the list.

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


