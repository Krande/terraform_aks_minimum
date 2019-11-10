resource "azurerm_dns_a_record" "azure_dns_a1" {
  name                = "@"
  zone_name           = var.root_address
  resource_group_name = var.az_dns_rg
  ttl                 = 10800
  records             = [azurerm_public_ip.public_ip.ip_address]
}

resource "azurerm_dns_a_record" "azure_dns_a2" {
  name                = "*"
  zone_name           = var.root_address
  resource_group_name = var.az_dns_rg
  ttl                 = 10800
  records             = [azurerm_public_ip.public_ip.ip_address]
}

resource "azurerm_dns_a_record" "azure_dns_a3" {
  name                = "www"
  zone_name           = var.root_address
  resource_group_name = var.az_dns_rg
  ttl                 = 10800
  records             = [azurerm_public_ip.public_ip.ip_address]
}