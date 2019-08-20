# tf_aks_minimal
A minimum terraform-setup on AKS hosting a pipserver created to address error in issuing certificate after converting 
yaml files to terraform.

This assumes you have a microsoft azure account, a domain name and set the dns to be handled by azure 
(how to setup this is better explained elsewhere)

## Fill in necessary variables
You need to create a terraform variables file "terraform.tfvars" in your folder and copy paste the following 

```
prefix = <"tfakstest">
dns_prefix = <"dnsprefix">
az_backend_key = <"prod.terraform.tfstate">
aks_client_id = <"azureclientid">
aks_client_secret = <"azureclientsecret">
az_subscription_id = <"azuresubscriptionid">
az_tenant_id = <"azuretenantid">
az_storage_name = <"azurestoragename">
az_storage_access_key = <"azurestorageccesskey">
domain_address = <"domainaddress.com">
email = <"youremail@something.com">
```

## Initialize
Start by running "make init" in a terminal in the folder 

(for windows user, install chocolatey package manager and install GNU Make using "choco install make")

After successful initiation run "terraform apply"

## Remaining work
Missing certificates. See my question [here](https://stackoverflow.com/questions/57499838/how-to-issue-letsencrypt-certificate-for-k8s-aks-using-terraform-resources)
on Stack Overflow regarding issuing certificates using Terraform resources (this repo is created to answer what I could 
not find anywhere else)  This issue is still not answered, so if anyone else have any ideas or any tips to improve this 
example I would really appreciate it!     

### Sources
* https://docs.microsoft.com/en-us/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks