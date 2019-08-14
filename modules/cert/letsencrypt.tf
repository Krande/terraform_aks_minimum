provider "acme" {
  server_url = var.context.cert_server
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    create_before_destroy = true
  }
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address = var.context.email

  lifecycle {
    create_before_destroy = true
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name = var.context.domain_address
  subject_alternative_names = []

  dns_challenge {
    provider = "azure"
    config = {
      AZURE_CLIENT_ID = var.context.client_id
      AZURE_CLIENT_SECRET = var.context.client_secret
      AZURE_SUBSCRIPTION_ID = var.context.azure_subscription_id
      AZURE_TENANT_ID = var.context.azure_tenant_id
      AZURE_RESOURCE_GROUP = var.context.azure_dns_rg
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}