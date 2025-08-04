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

  set = [
    {
      name  = "nameOverride"
      type  = "string"
      value = "ingress-nginx"
    },
    {
      name  = "fullnameOverride"
      type  = "string"
      value = "ingress-nginx"
    },
    {
      name  = "controller.kind"
      type  = "string"
      value = var.ingress_nginx_controller_kind
    },
    {
      name  = "controller.service.externalTrafficPolicy"
      type  = "string"
      value = var.ingress_nginx_controller_external_traffic_policy
    },
    {
      name  = "controller.metrics.enabled"
      type  = "string"
      value = var.ingress_nginx_controller_metrics_enabled
    }
  ]

  depends_on = [kubernetes_namespace.main]
}
