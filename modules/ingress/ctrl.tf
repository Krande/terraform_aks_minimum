resource "kubernetes_deployment" "nginx_ingress_controller" {
  metadata {
    name = "nginx-ingress-controller"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name

    labels = {
      "app.kubernetes.io/name" = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "ingress-nginx"
        "app.kubernetes.io/part-of" = "ingress-nginx"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "ingress-nginx"
          "app.kubernetes.io/part-of" = "ingress-nginx"
        }

        annotations = {
          "prometheus.io/port" = "10254"
          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.nginx_ingress_serviceaccount.metadata[0].name
        container {
          name = "nginx-ingress-controller"
          image = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0"
          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = kubernetes_service_account.nginx_ingress_serviceaccount.default_secret_name
            read_only = true
          }

          args = [
            "/nginx-ingress-controller",
            "--configmap=$(POD_NAMESPACE)/nginx-configuration",
            "--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services",
            "--udp-services-configmap=$(POD_NAMESPACE)/udp-services",
            "--publish-service=$(POD_NAMESPACE)/ingress-nginx",
            "--annotations-prefix=nginx.ingress.kubernetes.io"]

          port {
            name = "http"
            container_port = 80
          }

          port {
            name = "https"
            container_port = 443
          }

          env {
            name = "POD_NAME"

            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "10254"
              scheme = "HTTP"
            }

            initial_delay_seconds = 10
            timeout_seconds = 1
            period_seconds = 10
            success_threshold = 1
            failure_threshold = 3
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "10254"
              scheme = "HTTP"
            }

            timeout_seconds = 1
            period_seconds = 10
            success_threshold = 1
            failure_threshold = 3
          }

          security_context {
            run_as_user = 33
            allow_privilege_escalation = true
            capabilities {
              drop = [
                "ALL"]
              add = [
                "NET_BIND_SERVICE"]
            }
          }
        }

        volume {
          name = kubernetes_service_account.nginx_ingress_serviceaccount.default_secret_name
          secret {
            secret_name = kubernetes_service_account.nginx_ingress_serviceaccount.default_secret_name
          }
        }
      }

    }
  }
}

