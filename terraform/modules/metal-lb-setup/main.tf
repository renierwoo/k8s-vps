resource "terraform_data" "preparation" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/preparation.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/preparation.sh"
    destination = "/tmp/preparation.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/preparation.sh",
      "sudo /tmp/preparation.sh",
      "sudo rm --force /tmp/preparation.sh"
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


resource "kubernetes_namespace_v1" "metal_lb" {
  metadata {
    annotations = {
      name = "metallb-system"
    }

    labels = {
      "app.kubernetes.io/name"       = "metallb"
      "app.kubernetes.io/instance"   = "metallb"
      "app.kubernetes.io/version"    = var.metal_lb_chart_version
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/part-of"    = "metallb"
      "app.kubernetes.io/managed-by" = "terraform"

      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }

    name = "metallb-system"
  }

  depends_on = [terraform_data.preparation]
}


resource "helm_release" "metal_lb_setup" {
  chart = "metallb"
  name  = "metallb"

  description = "MetalLB is a load-balancer implementation for bare metal Kubernetes clusters."
  namespace   = kubernetes_namespace_v1.metal_lb.metadata[0].name
  repository  = "https://metallb.github.io/metallb"
  version     = var.metal_lb_chart_version

  depends_on = [kubernetes_namespace_v1.metal_lb]
}


resource "kubernetes_manifest" "ip_address_pool" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "IPAddressPool"

    "metadata" = {
      "name"      = "metal-lb-pool"
      "namespace" = kubernetes_namespace_v1.metal_lb.metadata[0].name
    }

    "spec" = {
      "addresses" = [
        "${var.connection_host}/32"
      ]

      "autoAssign"    = true
      "avoidBuggyIPs" = true
    }
  }
}


resource "kubernetes_manifest" "l2_advertisement" {
  manifest = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "L2Advertisement"

    "metadata" = {
      "name"      = "metal-lb-advertisement"
      "namespace" = kubernetes_namespace_v1.metal_lb.metadata[0].name
    }

    "spec" = {
      "ipAddressPools" = [
        kubernetes_manifest.ip_address_pool.manifest.metadata.name
      ]
    }
  }
}
