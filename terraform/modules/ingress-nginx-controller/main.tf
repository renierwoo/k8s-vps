resource "kubernetes_namespace" "main" {
  metadata {
    annotations = {
      name = "ingress-nginx"
    }

    labels = {
      "app.kubernetes.io/name"       = "ingress-nginx"
      "app.kubernetes.io/instance"   = "ingress-nginx"
      "app.kubernetes.io/version"    = var.ingress_nginx_controller_chart_version
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/part-of"    = "ingress-nginx"
      "app.kubernetes.io/managed-by" = "terraform"
    }

    name = "ingress-nginx"
  }
}


resource "helm_release" "main" {
  chart = "ingress-nginx"
  name  = "ingress-nginx"

  description = "Ingress NGINX Controller Helm Chart"
  namespace   = kubernetes_namespace.main.metadata[0].name
  repository  = "https://kubernetes.github.io/ingress-nginx"
  version     = var.ingress_nginx_controller_chart_version

  set {
    name  = "nameOverride"
    value = "ingress-nginx"
  }

  set {
    name  = "fullnameOverride"
    value = "ingress-nginx"
  }

  set {
    name  = "controller.kind"
    value = var.ingress_nginx_controller_kind
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = var.ingress_nginx_controller_external_traffic_policy
  }

  set {
    name  = "controller.metrics.enabled"
    value = var.ingress_nginx_controller_metrics_enabled
  }

  depends_on = [kubernetes_namespace.main]
}
