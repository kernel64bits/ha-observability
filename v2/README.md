 # Introduction
 Let's automate what we did in v1 using terraform. I also added the following improvements: 
 - Setup DNS server in the subnet ressource
 - 

 # Setup Terraform credentials
 ## Generate Terraform token
We first need to generate a token to give Terraform access to our OpenStack project. The ![OVH documentation](https://help.ovhcloud.com/csm/en-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050797) suggests to generate a global token with full access to our OVH account, which is convenient but not very secure. Let's do something a little bit better

### Get your project ID
Using the OVH API (https://eu.api.ovh.com/console), use the GET /cloud/project to list cloud project IDs. In my case it is de42b515209c417d957586a5ab18c80e

### Generate token
Let's generate a token with full access to our project. Use the following path to the 4 request types
/cloud/project/de42b515209c417d957586a5ab18c80e/*

Ensuite suivre la doc d'OVH + améliorer la gestion des tokens

# Setup

```bash
cd ha-observability/v2
terraform workspace new test_terraform
terraform init
terraform plan
```