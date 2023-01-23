# Sysdig Addon for EKS Blueprints

**_`This project is currently in BETA stage`_**

## Introduction
[Sysdig](https://sysdig.com) is a security and monitoring platform that helps organizations to confidently drive cloud and containers by providing insight from source to run. [Sysdig](https://sysdig.com) is built on open standards like [Falco](https://falco.org/), [OPA](https://www.openpolicyagent.org/) and [Prometheus](https://prometheus.io/).

This project contains the [Sysdig](https://sysdig.com) Terraform add-on for [AWS EKS Blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints) as well as a set of prebuilt  [blueprint(s)](/blueprints/) ready to start creating clusters fast and easy.

## EKS add-ons and blueprints

With this [Sysdig Addon for EKS Blueprints](https://github.com/sysdiglabs/terraform-eksblueprints-sysdig-addon) you can provision EKS clusters tailored to your needs and secured from day-zero as they are deployed together with the [Sysdig agents](https://docs.sysdig.com/en/docs/installation/sysdig-agent/). This add-on and the blueprints extends the framework [AWS EKS Blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints).

- **Getting Started** The [Getting Started Blueprint](/blueprints/getting-started/) provisions a basic cluster with the most common Sysdig instrumentation for both Secure and Monitor use cases.  

- **Security Laboratory** The [Security Lab Blueprint](/blueprints/lab-security/) creates a cluster with an example application to generate suspicious runtime events and vulnerabilities to be detected out of the box by the Sysdig probe that is also installed with this automation.  

- **Monitor and Alerting** The [Monitor and alerting](/blueprints/monitor-alerts/) set up a cluster monitored by the sysdig agents and defines Notification Channels and Alerts as code.


## Requirements

* Terraform >= 1.0.0 (Recommended > 1.3.0)
* AWS Command Line and credentials
* A Sysdig account. You can register your [Sysdig Free Trial](https://sysdig.com/company/start-free/) and start experimenting on how to secure an EKS cluster now.

## Training

* EKS Blueprints for Terraform official workshop: https://catalog.workshops.aws/eks-blueprints-terraform/en-US

* Sysdig AWS workshops: https://sysdig.awsworkshop.io

## Terraform Documentation
<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addon_context | Input configuration for the addon | <pre>object({<br>    aws_caller_identity_account_id = string<br>    aws_caller_identity_arn        = string<br>    aws_eks_cluster_endpoint       = string<br>    aws_partition_id               = string<br>    aws_region_name                = string<br>    eks_cluster_id                 = string<br>    eks_oidc_issuer_url            = string<br>    eks_oidc_provider_arn          = string<br>    tags                           = map(string)<br>  })</pre> | n/a | yes |
| cluster_name | Cluster Name | `string` | `"testcluster"` | no |
| helm_config | Helm Configuration for Sysdig Agent | `any` | `{}` | no |
| manage_via_gitops | Determines if the add-on should be managed via GitOps | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| argocd_gitops_config | Configuration used for managing the add-on with ArgoCD |
<!-- END_TF_DOCS -->
