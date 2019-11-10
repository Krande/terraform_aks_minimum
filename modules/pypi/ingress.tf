resource "kubernetes_ingress" "pypi" {
  depends_on = [var.ingress]
  metadata {
    name = "pypi"
    namespace = kubernetes_namespace.pypi.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "kubernetes.io/tls-acme" = "true"
      "certmanager.k8s.io/cluster-issuer" = "letsencrypt-${var.cert_type}"
      "certmanager.k8s.io/acme-http01-edit-in-place": "true"
    }
    labels = {
      app= "pypi"
      heritage = "Tiller"
    }
  }

  spec {
    tls {
      hosts = [var.root_address]
      secret_name = "pypi-${var.cert_type}-letsencrypt"

    }

    rule {
      host = var.root_address
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
    rule {
      host = "www.${var.root_address}"
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