resource "terraform_data" "cilium_setup" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/cilium-setup.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/cilium-setup.sh"
    destination = "/tmp/cilium-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cilium-setup.sh",
      "sudo /tmp/cilium-setup.sh ${var.cilium_cli_version} ${var.cilium_version} ${var.ipam_mode} ${var.pod_network_cidr}",
      "sudo rm --force /tmp/cilium-setup.sh"
    ]
  }

  connection {
    type        = var.connection_type
    user        = var.connection_user
    host        = var.connection_host
    port        = var.connection_port
    private_key = var.connection_private_key
  }
}


resource "terraform_data" "hubble_setup" {
  count = var.enable_hubble ? 1 : 0

  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/hubble-setup.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/hubble-setup.sh"
    destination = "/tmp/hubble-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/hubble-setup.sh",
      "sudo /tmp/hubble-setup.sh ${var.hubble_cli_version} ${var.hubble_enabled_ui}",
      "sudo rm --force /tmp/hubble-setup.sh"
    ]
  }

  connection {
    type        = var.connection_type
    user        = var.connection_user
    host        = var.connection_host
    port        = var.connection_port
    private_key = var.connection_private_key
  }
}


resource "kubernetes_secret_v1" "hubble_ui_basic_auth" {
  metadata {
    annotations = {
      name = "hubble-ui-basic-auth"
    }

    labels = {
      "app.kubernetes.io/name"       = "hubble-ui"
      "app.kubernetes.io/instance"   = "hubble-ui"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/part-of"    = "hubble"
      "app.kubernetes.io/managed-by" = "terraform"
    }

    name      = "hubble-ui-basic-auth"
    namespace = "kube-system"
  }

  data = {
    auth = "${var.hubble_ui_username}:${var.hubble_ui_password}"
  }

  type = "Opaque"
}


resource "kubernetes_secret_v1" "hubble_ui_tls" {
  metadata {
    annotations = {
      name = "hubble-ui-tls"
    }

    labels = {
      "app.kubernetes.io/name"       = "hubble-ui"
      "app.kubernetes.io/instance"   = "hubble-ui"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/part-of"    = "hubble"
      "app.kubernetes.io/managed-by" = "terraform"
    }

    name      = "hubble-ui-tls"
    namespace = "kube-system"
  }

  data = {
    "tls.crt" = var.main_domain_tls_cert
    "tls.key" = var.main_domain_tls_key
  }

  type = "Opaque"
}


resource "kubernetes_ingress_v1" "hubble_ui" {
  metadata {
    annotations = {
      "nginx.ingress.kubernetes.io/auth-type"   = "basic"
      "nginx.ingress.kubernetes.io/auth-secret" = kubernetes_secret_v1.hubble_ui_basic_auth.metadata[0].name
      "nginx.ingress.kubernetes.io/auth-realm"  = "Authentication Required"
    }

    labels = {
      "app.kubernetes.io/name"       = "hubble-ui"
      "app.kubernetes.io/instance"   = "hubble-ui"
      "app.kubernetes.io/component"  = "server"
      "app.kubernetes.io/part-of"    = "hubble"
      "app.kubernetes.io/managed-by" = "terraform"
    }

    name      = "hubble-ui"
    namespace = "kube-system"
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = var.hubble_ui_domain

      http {
        path {
          backend {
            service {
              name = "hubble-ui"

              port {
                number = 80
              }
            }
          }

          path      = "/"
          path_type = "Prefix"
        }
      }
    }

    tls {
      hosts = [
        var.hubble_ui_domain
      ]

      secret_name = kubernetes_secret_v1.hubble_ui_tls.metadata[0].name
    }
  }
}
