# Sysdidg Addon for EKS Blueprints

**`This project is currently in BETA stage`**

## Introduction
[Sysdig](https://sysdig.com) is a security and monitoring platform that helps organizations to confidently manage cloud and containers from source to run. One of the particularities of [Sysdig](https://sysdig.com) is the ability to seamlessly provide context from Kubernetes clusters as it is built on top of [Falco](https://falco.org/), the de-facto standard for runtime security donated to the CNCF.

This project contains the [Sysdig](https://sysdig.com) add-on for [AWS EKS Blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints) as well as the [base blueprint(s)](/blueprints/).

## EKS add-ons and blueprints

With this [Sysdig Addon for EKS Blueprints](https://github.com/sysdiglabs/terraform-eksblueprints-sysdig-addon) you can provision EKS clusters tailored to your needs and secured from day-zero as they are deployed together with the [Sysdig agents](https://docs.sysdig.com/en/docs/installation/sysdig-agent/) as well as a set of optional components. 

This add-on and the blueprints extends the framework [AWS EKS Blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints).

## Addon usage examples

Check out the [blueprints](/blueprints/) to undesrtand how to use and extend the Sysdig add-on to provision your AWS EKS clusters and keep them secured and monitored with not a single blind spot.
 
The [Getting Started blueprint](/blueprints/getting-started/) illustrates the basic cluster with the most common Sysdig instrumentation for both Secure and Monitor use cases.

## Requirements

* Terraform >= 1.0.0 (Recommended > 1.3.0)
* AWS cli configured and connected using enough credentials.
* A Sysdig account. You can register your (Sysdig Free Trial)[https://sysdig.com/company/start-free/] and start experimenting on how to secure an EKS cluster now.

## Terraform Documentation

<!--- BEGIN_TF_DOCS --->

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_helm_addon"></a> [helm\_addon](#module\_helm\_addon) | github.com/aws-samples/aws-eks-accelerator-for-terraform//modules/kubernetes-addons/helm-addon | n/a |

### Resources

| Name | Type |
|------|---------|
| <a name="resource_random_string.id"></a> [random\_string](#resource\_random\_string) | resource |


### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addon_context"></a> [addon\_context](#input\_addon\_context) | Input configuration for the addon | `any` | n/a | yes |
| <a name="input_helm_config"></a> [helm\_config](#input\_helm\_config) | Helm chart configuration | `any` | `{}` | no |

### Outputs

No output

<!--- END_TF_DOCS --->