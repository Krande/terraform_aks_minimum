provider "acme" {
  server_url = var.cert_type == "prod" ? var.cert_prod : var.cert_staging
}

resource "tls_private_key" "reg_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.reg_private_key.private_key_pem
  email_address = var.email
}

resource "tls_private_key" "cert_private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "req" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.cert_private_key.private_key_pem
  dns_names       = ["*.${var.root_address}", var.root_address]

  subject {
    common_name = var.root_address
  }
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  certificate_request_pem = tls_cert_request.req.cert_request_pem

  dns_challenge {
    provider = "azure"
    config = {
      AZURE_CLIENT_ID = var.client_id
      AZURE_CLIENT_SECRET = var.client_secret
      AZURE_SUBSCRIPTION_ID = var.az_subscription_id
      AZURE_TENANT_ID = var.az_tenant_id
      AZURE_RESOURCE_GROUP = var.az_dns_rg
    }
  }
}