# Set default name prefix
variable "name_prefix" {
  default = "tfaksmin"
}

# Set default location
variable "location" {
  default = "northeurope"
}

variable "cert_type" {
  description = "prod or staging acme certificate"
  default = "staging"
}

variable "email" {
  description = "Email linked to your generated certificate"
}

variable "root_address" {
  description = "Root address of your domain"
}

variable "az_dns_rg" {
  default = "azure_dns"
}

variable "ingress_class" {
  default = "nginx"
}


#region Azure specific variables
variable "az_subscription_id" {
  description = "Your Azure Subscription ID"
}
variable "az_tenant_id" {
  description = "Your Azure tenant ID"
}
variable "az_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}
variable "az_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}
#endregion

#region AKS TF States
variable "az_storage_rg" {
  description = "Azure Storage Resource Group for State Storage"
}
variable "az_storage_cont" {
  description = "Azure Storage Container for State Storage"
}
variable "az_storage_name" {
  description = "Your azure storage for hosting TF state files"
}
variable "az_storage_access_key" {
  description = "Your Azure access token"
}
variable "az_backend_key" {
}
#endregion