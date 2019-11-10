# Create Static Public IP Address to be used by Nginx Ingress
resource "azurerm_resource_group" "aks-ip-rg" {
  name = "ingress-ip"
  location = var.location
}

resource "azurerm_public_ip" "public_ip" {
  name = "nginx-ingress-pip"
  location = azurerm_resource_group.aks-ip-rg.location
  allocation_method = "Static"
  resource_group_name = azurerm_resource_group.aks-ip-rg.name
  domain_name_label = var.name_prefix
}

resource "azurerm_role_assignment" "aks-ip-rg" {
  scope = azurerm_resource_group.aks-ip-rg.id
  role_definition_name = "Contributor"
  principal_id = var.principal_id
}

#region Ingress setup
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = var.ingress_namespace
  }
}

# Add Kubernetes Stable Helm charts repo
data "helm_repository" "stable" {
  depends_on = [var.wait_on]
  name = "stable"
  url = "https://kubernetes-charts.storage.googleapis.com"
}

resource "null_resource" "update_stable_repo" {
  depends_on = [data.helm_repository.stable]

  provisioner "local-exec" {
    command = "helm repo update"
  }
}

# Install Nginx Ingress using Helm Chart
resource "helm_release" "nginx_ingress" {
  depends_on = [null_resource.update_stable_repo]
  name = "nginx-ingress"
  repository = "stable"
  namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
  chart = "nginx-ingress"
  timeout = 1000
  wait = true

  set {
    name = "rbac.create"
    value = "true"
  }

  set {
    name = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = azurerm_resource_group.aks-ip-rg.name
  }

  set {
    name = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.public_ip.ip_address
  }
}
#endregion