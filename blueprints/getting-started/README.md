# Getting Started Sysdig Terraform Blueprint for EKS

## Prerequisites

Initialize TF VARS with the proper credentials and urls from your Sysdig SaaS account and region.
https://docs.sysdig.com/en/docs/administration/saas-regions-and-ip-ranges

```
export TF_VAR_sysdig_accesskey=<sysdig-agent-accesskey>
export TF_VAR_sysdig_collector_endpoint=<sysdig_collector_endpoint>
export TF_VAR_nodeanalyzer-api-endpoint=<sysdig_nodeanalyzer_api_endpoint>
```

Example with an account from Sysdig us-west (us2)

```
export TF_VAR_sysdig_accesskey=fa3efa3e-95ee-4233-b222-fa3efa3e8120a
export TF_VAR_sysdig_collector_endpoint=ingest-us2.app.sysdig.com
export TF_VAR_nodeanalyzer-api-endpoint=us2.app.sysdig.com
```
