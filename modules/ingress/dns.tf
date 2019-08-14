resource "azurerm_dns_a_record" "azure_dns_a1" {
  name                = "@"
  zone_name           = var.az_dns_zone
  resource_group_name = var.azure_dns_rg_name
  ttl                 = 10800
  records             = [kubernetes_service.ingress_nginx_inet.load_balancer_ingress.0.ip]
}

resource "azurerm_dns_a_record" "azure_dns_a2" {
  name                = "*"
  zone_name           = var.az_dns_zone
  resource_group_name = var.azure_dns_rg_name
  ttl                 = 10800
  records             = [kubernetes_service.ingress_nginx_inet.load_balancer_ingress.0.ip]
}

resource "azurerm_dns_a_record" "azure_dns_a3" {
  name                = "www"
  zone_name           = var.az_dns_zone
  resource_group_name = var.azure_dns_rg_name
  ttl                 = 10800
  records             = [kubernetes_service.ingress_nginx_inet.load_balancer_ingress.0.ip]
}