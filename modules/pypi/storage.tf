resource "kubernetes_namespace" "pypi" {
  metadata {
    name = "pypi-ns"
  }
}

resource "kubernetes_storage_class" "azurefile_uid_500_gid_500_dir_0777_file_0777" {
  metadata {
    name = "azurefile-uid-500-gid-500-dir-0777-file-0777"
  }

  parameters = {
    skuName = "Standard_LRS"
  }
  storage_provisioner = "kubernetes.io/azure-file"
  #mount_options          = ["dir_mode=0777", "file_mode=0777", "uid=500", "gid=500"]
  allow_volume_expansion = true
}

resource "kubernetes_persistent_volume_claim" "pypi_data" {
  metadata {
    name      = "pypi-data"
    namespace = kubernetes_namespace.pypi.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "100Mi"
      }
    }

    storage_class_name = "azurefile-uid-500-gid-500-dir-0777-file-0777"
  }
}

