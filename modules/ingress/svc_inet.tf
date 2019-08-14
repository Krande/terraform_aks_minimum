resource "kubernetes_service" "ingress_nginx_inet" {
  metadata {
    name      = "ingress-nginx-inet"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx-inet"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }

    port {
      name        = "https"
      protocol    = "TCP"
      port        = 443
      target_port = "443"
    }

    selector = {
      "app.kubernetes.io/name"    = "ingress-nginx-inet"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }

    type = "LoadBalancer"
  }
}

