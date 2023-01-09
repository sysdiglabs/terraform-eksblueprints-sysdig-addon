# Maintenance instruction

This document outlines basic procedures for maintenance and development of this addon.

Any change affecting the add-on (base path) must be propagated to the base framework as well as the Terraform module.

1. Keep version, variables and examples updated in the [AWS EKS add-ons framework](https://github.com/aws-ia/terraform-aws-eks-blueprints) following the contribution instruction from the [extensibility guide](https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/docs/extensibility.md). 
IMPORTANT: Make sure that the right version of the add-on is referenced https://github.com/aws-ia/terraform-aws-eks-blueprints/edit/main/modules/kubernetes-addons/main.tf


2. Generate a [new release](https://github.com/sysdiglabs/terraform-eksblueprints-sysdig-addon/releases) and sync the [Sysdig addon for EKS Terraform Module](https://registry.terraform.io/modules/sysdiglabs/sysdig-addon/eksblueprints/latest)
