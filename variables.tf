# General Variables
variable "prefix" {
  description = "Prefix"
}
variable "dns_prefix" {
  description = "Forms part of the fully qualified domain name (FQDN) used to access the cluster"
}

# Azure specific variables
variable "az_subscription_id" {
  description = "Your Azure Subscription ID"
}
variable "az_tenant_id" {
  description = "Your Azure tenant ID"
}

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
variable "az_dns_rg" {
  description = "Name of azure dns resource group"
  default = "azure_dns"
}

# AKS specific variables
variable "aks_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}
variable "aks_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

# Pypi specific details
variable "domain_address" {
  description = ""
}

# Certificate
variable "email" {
  description = "Your email relevant for letsencrypt certificate"
}

variable "cert_type" {
  description = "prod or staging acme certificate"
  default = "staging"
  #default = "prod"
}

variable "cert_staging" {
  description = "The letsencrypt staging certificate issuer server address"
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "cert_prod" {
  description = "The letsencrypt production certificate issuer server address"
  default = "https://acme-v02.api.letsencrypt.org/directory"
}


locals {
  context = {
    host = azurerm_kubernetes_cluster.aksdemo.kube_config[0].host
    azure_dns_rg = var.az_dns_rg
    client_id = var.aks_client_id
    client_certificate = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.client_certificate)
    client_key = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.cluster_ca_certificate)
    client_secret = var.aks_client_secret
    azure_subscription_id = var.az_subscription_id
    azure_tenant_id = var.az_tenant_id
    cert_type = var.cert_type
    cert_staging = var.cert_staging
    cert_prod = var.cert_prod
    email = var.email
    domain_address = var.domain_address
  }
}