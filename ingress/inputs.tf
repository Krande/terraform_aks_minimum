variable "ingress_namespace" {}
variable "cert_namespace" {}
variable "root_address" {}
variable "cert_type" {}
variable "principal_id" {}
variable "principal_pwd" {}
variable "email" {}
variable "az_dns_rg" {}
variable "name_prefix" {}
variable "cert_staging" {
  description = "The letsencrypt staging certificate issuer server address"
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "cert_prod" {
  description = "The letsencrypt production certificate issuer server address"
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "location" {
  default = "northeurope"
}
variable "az_rg" {}
variable "az_subscription_id" {}
variable "az_tenant_id" {}
variable "client_id" {}
variable "client_certificate" {}
variable "client_key" {}
variable "cluster_ca_certificate" {}
variable "client_secret" {}
variable "wait_on" {}