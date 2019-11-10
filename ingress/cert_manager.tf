# Install the CustomResourceDefinitions and cert-manager itself
resource "null_resource" "kube_config_add" {
  depends_on = [helm_release.nginx_ingress]
  provisioner "local-exec" {
    command = "set KUBECONFIG=.kubeconfig"
    interpreter = ["cmd"]
  }

}

resource "null_resource" "cert_crd_install" {
  depends_on = [null_resource.kube_config_add]
  provisioner "local-exec" {
    command = "kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = var.cert_namespace
    labels = {
      "certmanager.k8s.io/disable-validation": "true"
    }
  }
}


data "helm_repository" "jetstack" {
  depends_on = [null_resource.cert_crd_install]
  name = "jetstack"
  url = "https://charts.jetstack.io"
}

resource "null_resource" "repo_update" {
  depends_on = [data.helm_repository.jetstack]
  provisioner "local-exec" {
    command = "helm repo update"
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [null_resource.repo_update]
  keyring = ""
  name = "cert-manager"
  chart = "jetstack/cert-manager"
  namespace = kubernetes_namespace.cert_manager.metadata[0].name
  version = "v0.11.0"

  set {
    name = "rbac.create"
    value = "true"
  }

  set {
    name = "webhook.enabled"
    value = "true"
  }

  set {
    name = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }

  set {
    name = "ingressShim.defaultIssuerName"
    value = "letsencrypt-${var.cert_type}"
  }


}

resource "local_file" "cert_file" {
  depends_on = [null_resource.repo_update]
  content = templatefile("${path.module}/cert.tpl", {
    cert_type = var.cert_type,
    cert_server = var.cert_type == "prod" ? var.cert_prod : var.cert_staging,
    email = var.email
  })
  filename = "${path.module}/letsencrypt.yaml"
}

resource "null_resource" "cert_apply" {
  depends_on = [helm_release.cert_manager]
  provisioner "local-exec" {
    command = "kubectl --insecure-skip-tls-verify=true create -f ${local_file.cert_file.filename}"
  }
}