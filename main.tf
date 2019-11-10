provider "azurerm" {
}

terraform {
  backend "azurerm" {
  }
}

# Create Resource Groups
resource "azurerm_resource_group" "aksrg" {
  name = "${var.name_prefix}-rg"
  location = var.location
}

# Create Azure AD Application for Service Principal
resource "azuread_application" "aksad" {
  name = "${var.name_prefix}-sp"
}

# Create Service Principal
resource "azuread_service_principal" "akssp" {
  application_id = azuread_application.aksad.application_id
}

# Generate random string to be used for Service Principal Password
resource "random_string" "password" {
  length = 32
  special = true
}

# Create Service Principal password
resource "azuread_service_principal_password" "akspwd" {
  end_date = "2299-12-30T23:00:00Z"
  # Forever
  service_principal_id = azuread_service_principal.akssp.id
  value = random_string.password.result
}

# Create managed Kubernetes cluster (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name = "${var.name_prefix}-aks"
  location = azurerm_resource_group.aksrg.location
  resource_group_name = azurerm_resource_group.aksrg.name
  dns_prefix = var.name_prefix
  #kubernetes_version = "1.14.6"

  agent_pool_profile {
    name = "linuxpool"
    count = 1
    vm_size = "Standard_B2ms"
    os_type = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id = azuread_application.aksad.application_id
    client_secret = azuread_service_principal_password.akspwd.value
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    Environment = "development"
  }
}

# Initialize Helm (and install Tiller)
provider "helm" {
  install_tiller = true

  kubernetes {
    host = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
    config_path = ".kubeconfig"
  }
}

resource "null_resource" "set_config" {

  provisioner "local-exec" {
    command = "set KUBECONFIG=.kubeconfig"
  }
}

module "ingress" {
  source = "./ingress"
  wait_on=null_resource.set_config
  ingress_namespace = "ingress-nginx"
  cert_namespace = "cert-manager"
  principal_id = azuread_service_principal.akssp.id
  principal_pwd = azuread_service_principal_password.akspwd.value

  client_id = var.az_client_id
  client_secret = var.az_client_secret
  client_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  az_tenant_id = var.az_tenant_id
  az_subscription_id = var.az_subscription_id
  az_rg = var.az_dns_rg
  root_address = var.root_address
  cert_type = var.cert_type
  email = var.email
  name_prefix = var.name_prefix
  az_dns_rg = var.az_dns_rg
}


module "pypi" {
  source = "./modules/pypi"
  namespace = "tfmin-pypi"
  root_address = var.root_address
  cert_type = var.cert_type
  ingress = module.ingress.cert_manager
}