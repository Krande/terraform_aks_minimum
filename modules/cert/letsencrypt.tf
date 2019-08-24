provider "acme" {
  server_url = var.context.cert_server
}

resource "tls_private_key" "reg_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address = var.context.email
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "req" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.cert_private_key.private_key_pem
  dns_names       = [var.context.domain_address]

  subject {
    common_name = var.context.domain_address
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  certificate_request_pem = tls_cert_request.req.cert_request_pem

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
}