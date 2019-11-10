resource "kubernetes_namespace" "pypi" {
  metadata {
    name = var.namespace
  }
}