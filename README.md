# tf_aks_minimal
A minimum terraform-setup on AKS hosting a pipserver. This example was created to supplement a stack overflow question 
([here](https://stackoverflow.com/questions/57499838/how-to-issue-letsencrypt-certificate-for-k8s-aks-using-terraform-resources)) 
with the intent of addressing an error in issuing certificates after converting yaml files to terraform.

The answer to my question was that I had to include a cert-manager to my cluster. I ended up using Helm for my ingress 
and cert manager. The setup ended up a bit more complex than I initially imagined, but still it works. I guess there 
probably are ways of simplifying the pypi deployment part using native terraform resourcse, but I have not had time to
investigate further.  

If anyone have tips for a more elegant and functional minimum terraform setup for a k8s cluster I would love to hear it! 


## Requirements
This assumes you have a microsoft azure account, a domain name, azure storage account and have the dns to be handled by 
azure (how to setup this is better explained elsewhere)

For windows user, install chocolatey package manager and install GNU Make using "choco install make".

## Fill in necessary variables
You need to create a terraform variables file "terraform.tfvars" in your folder and copy paste the following 

```
# Azure Login details
az_client_id = <"Azure client ID">
az_client_secret = <"Azure client secret">
az_subscription_id = <"Azure subscription ID">
az_tenant_id = <"Azure Tenant ID">

# AKS TF State storage
az_storage_rg = <"Azure storage resource group">
az_storage_name = <"Storage blob name">
az_storage_cont = <"Storage container name">
az_storage_access_key = <"Storage Access key">
az_backend_key = "prod.terraform.tfstate"

# Domain Specifics
az_dns_rg = <"Azure DNS resource group">
root_address = <"Your domain address">
email = <"Your email">
```

## Initialize

* Start by running "make init" in a terminal in the folder 

* After successful initiation run "terraform apply"

* lastly to interact with your kubernetes cluster after use (on windows) "set KUBECONFIG=.kubeconfig"

### Sources
* https://docs.microsoft.com/en-us/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks