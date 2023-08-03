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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the Sysdig Helm Chart to deploy | `string` | `"1.17.0"` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Whether to create the namespace to deploy the Sysdig Helm Chart into | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the Sysdig Helm Chart to deploy | `string` | `"Sysdig agent Helm chart"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to deploy the Sysdig Helm Chart into | `string` | `"sysdig"` | no |
| <a name="input_set"></a> [set](#input\_set) | Value block with custom values to be merged with the values yaml | `any` | `[]` | no |
| <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive) | Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff | `any` | `[]` | no |
| <a name="input_values"></a> [values](#input\_values) | The values to pass to the Sysdig Helm Chart | `list(string)` | <pre>[<br>  "global:\n  kspm:\n    deploy: true\nebpf:\n    enabled: false\nnodeAnalyzer:\n  nodeAnalyzer:\n    benchmarkRunner:\n      deploy: false\n    runtimeScanner:\n      settings:\n        eveEnabled: true\n  secure:\n    vulnerabilityManagement:\n      newEngineOnly: true\n"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
