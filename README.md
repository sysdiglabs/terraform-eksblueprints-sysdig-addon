# Sysdidg Addon for EKS Blueprints

**`This project is currently in BETA stage`**

## Introduction
[Sysdig](https://sysdig.com) is a security and monitoring platform that helps organizations to confidently manage cloud and containers from source to run. One of the particularities of [Sysdig](https://sysdig.com) is the ability to seamlessly provide context from Kubernetes clusters as it is built on top of [Falco](https://falco.org/), the de-facto standard for runtime security donated to the CNCF.

This project contains the [Sysdig](https://sysdig.com) add-on for [AWS EKS Blueprints](https://github.com/aws-ia/terraform-aws-eks-blueprints).

## EKS add-ons and blueprints

With [Sysdig Addon for EKS Blueprints](https://github.com/sysdiglabs/terraform-eksblueprints-sysdig-addon) you can provision EKS clusters tailored to your needs and secured from day zero as they are deployed together with the [Sysdig agents](https://docs.sysdig.com/en/docs/installation/sysdig-agent/) as well as a set of optional components/automations.

This add-on and blueprints extends [EKS Blueprints](https://github.com/aws-samples/aws-eks-accelerator-for-terraform).

## Blueprint Examples

## Requirements

| Name |
|------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) >= 1.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) |

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

No resources.

### Inputs

TODO (Pending)
<!--- END_TF_DOCS --->
