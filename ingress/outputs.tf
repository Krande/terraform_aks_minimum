output "ip" {
  value = ""
}
output "nginx_ingress" {
  value = helm_release.nginx_ingress
}

output "cert_manager" {
  value = helm_release.cert_manager
}

output "cert_issuer" {
  value = null_resource.cert_apply
}