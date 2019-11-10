resource "kubernetes_namespace" "pypi" {
  #depends_on = [var.ingress]
  metadata {
    name = var.namespace
  }
}