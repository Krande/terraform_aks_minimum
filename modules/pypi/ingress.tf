resource "kubernetes_ingress" "pypi" {
  depends_on = [var.ingress]
  metadata {
    name = "pypi"
    namespace = kubernetes_namespace.pypi.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      #"kubernetes.io/ingress.class" = "inet"
      "kubernetes.io/tls-acme" = "true"
      "certmanager.k8s.io/cluster-issuer" = "letsencrypt-${var.cert_type}"
      #"cert-manager.io/cluster-issuer" = "letsencrypt-${var.cert_type}"
      "certmanager.k8s.io/acme-http01-edit-in-place": "true"
      #"ingress.kubernetes.io/ssl-redirect" = "true"
    }
    labels = {
      app= "pypi"
      heritage = "Tiller"
    }
  }

  spec {
    tls {
      hosts = ["pypi.${var.root_address}"]
      secret_name = "pypi-${var.cert_type}-letsencrypt"

    }

    rule {
      host = "pypi.${var.root_address}"
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
      host = "www.pypi.${var.root_address}"
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