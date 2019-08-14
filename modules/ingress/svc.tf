resource "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/part-of" = "ingress-nginx"
      "app.kubernetes.io/name"    = "ingress-nginx"
    }
  }

  spec {
    port {
      name        = "http"
      port        = 80
      target_port = "80"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "443"
    }

    selector = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }

    type = "ClusterIP"
  }
}

