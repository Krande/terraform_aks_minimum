resource "kubernetes_service" "pypi" {
  metadata {
    name      = "pypi"
    namespace = kubernetes_namespace.pypi.metadata[0].name

    labels = {
      name = "pypi"
    }
  }

  spec {
    port {
      name = "http"
      port = 8080
    }

    selector = {
      app = "pypi"
    }

    type = "ClusterIP"
  }
}