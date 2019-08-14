# Configure the provider
provider "azurerm" {
  version = "=1.30.1"
}

terraform {
  backend "azurerm" {
  }
}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = "northeurope"
}

# Create Kubernetes cluster
resource "azurerm_kubernetes_cluster" "aksdemo" {
  name = "${var.prefix}-k8s"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix = var.dns_prefix

  agent_pool_profile {
    name = "default"
    count = 1
    vm_size = "Standard_B2ms"
    os_type = "Linux"
    os_disk_size_gb = 32
  }

  service_principal {
    client_id = var.aks_client_id
    client_secret = var.aks_client_secret
  }

  tags = {
    Environment = "dev"
  }
}

# Kubernetes Resources
provider "kubernetes" {
  host = azurerm_kubernetes_cluster.aksdemo.kube_config[0].host
  client_certificate = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.client_certificate)
  client_key = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.cluster_ca_certificate)
  config_path = "./.kube/config"
}

resource "kubernetes_namespace" "aksdemo" {
  metadata {
    name = "${var.prefix}-ns"
  }
}

# setup to output your kubeconfig from your terraform build
resource "local_file" "kubeconfig" {
  content = azurerm_kubernetes_cluster.aksdemo.kube_config_raw
  filename = ".kubeconfig"
}

module "ingress" {
  source = "./modules/ingress"
  azure_dns_rg_name = var.azure_dns_rg
  az_dns_zone = var.domain_address
}



module "cert" {
  source = "./modules/cert"
  context = local.context
}

module "pypi" {
  source = "./modules/pypi"
  pypi_address = var.domain_address
}