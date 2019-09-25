resource "null_resource" "pre_set" {
  depends_on = [
    var.ip_address]
  provisioner "local-exec" {
    #command = "kubectl  --insecure-skip-tls-verify=true apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.10/deploy/manifests/00-crds.yaml"
    command = "kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.7/deploy/manifests/00-crds.yaml"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  depends_on = [
    null_resource.pre_set]
  metadata {

    name = "cert-manager2"
  }
}

resource "null_resource" "label" {
  depends_on = [kubernetes_namespace.cert_manager]
  provisioner "local-exec" {
    command = "kubectl label namespace ${kubernetes_namespace.cert_manager.metadata[0].name} certmanager.k8s.io/disable-validation=true"
  }
  provisioner "local-exec" {
    command = "helm repo add jetstack https://charts.jetstack.io"
  }
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

resource "null_resource" "helm_install" {
  depends_on = [
    null_resource.label]
  provisioner "local-exec" {
    command = "helm install --name cert-manager --namespace ${kubernetes_namespace.cert_manager.metadata[0].name} --version v0.7.0 jetstack/cert-manager"
  }

}

#resource "helm_release" "cert_manager" {
#  keyring = ""
#  name = "cert-manager"
#  chart = "jetstack/cert-manager"
#  namespace = kubernetes_namespace.cert_manager
#  version = "v0.7.0"
#
#  depends_on = [
#    null_resource.helm_install]
#
#  set {
#    name = "email"
#    value = var.context.email
#  }
#  set {
#    name = "server"
#    value = var.context.cert_type == "prod" ? var.context.cert_prod : var.context.cert_staging
#  }
#
#  set {
#    name = "default-issuer-nam"
#    value = "letsencrypt-${var.context.cert_type}"
#  }
#}