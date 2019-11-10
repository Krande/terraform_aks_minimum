resource "kubernetes_deployment" "pypi" {
  depends_on = [var.ingress]
  metadata {
    name = "pypi"
    namespace = kubernetes_namespace.pypi.metadata[0].name
    labels = {
      app = "pypi"
      heritage = "Tiller"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pypi"
      }
    }

    template {
      metadata {
        labels = {
          app = "pypi"
          name = "pypi"
        }
      }

      spec {
        volume {
          name = "pypi-data"

          persistent_volume_claim {
            claim_name = "pypi-data"
          }
        }

        container {
          name = "pypi"
          image = "acrkris.azurecr.io/pypiserver:latest"

          port {
            name = "http"
            container_port = 8080
          }

          volume_mount {
            name = "pypi-data"
            mount_path = "/data/packages"
          }

          image_pull_policy = "Always"
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}