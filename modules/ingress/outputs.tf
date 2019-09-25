output "ip_address" {
  value = kubernetes_service.ingress_nginx_inet.load_balancer_ingress.0.ip
}