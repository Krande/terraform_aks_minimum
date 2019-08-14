resource "kubernetes_ingress" "pypi" {
  metadata {
    name = "pypi"
    namespace = kubernetes_namespace.pypi.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class" = "inet"
      "kubernetes.io/tls-acme" = "true"
      "certmanager.k8s.io/cluster-issuer" = "letsencrypt-prod"
      "ingress.kubernetes.io/ssl-redirect" = "true"
    }
  }

  spec {
    tls {
      hosts = [var.pypi_address]
    }
    rule {
      host = var.pypi_address

      http {
        path {
          path = "/"

          backend {
            service_name = kubernetes_service.pypi.metadata[0].name
            service_port = "http"
          }
        }
      }
    }
  }
}