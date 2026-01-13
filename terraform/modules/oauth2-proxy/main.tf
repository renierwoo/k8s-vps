# resource "kubernetes_namespace_v1" "main" {
#   metadata {
#     annotations = {
#       name = "oauth2-proxy"
#     }

#     labels = {
#       "app.kubernetes.io/name"       = "oauth2-proxy"
#       "app.kubernetes.io/instance"   = "oauth2-proxy"
#       "app.kubernetes.io/version"    = var.oauth2_proxy_chart_version
#       "app.kubernetes.io/component"  = "controller"
#       "app.kubernetes.io/part-of"    = "oauth2-proxy"
#       "app.kubernetes.io/managed-by" = "terraform"
#     }

#     name = "oauth2-proxy"
#   }
# }

# resource "helm_release" "main" {
#   chart = "oauth2-proxy"
#   name  = "oauth2-proxy"

#   description = "OAuth2 Proxy Helm Chart"
#   namespace   = kubernetes_namespace_v1.main.metadata[0].name
#   repository  = "https://oauth2-proxy.github.io/manifests"
#   version     = var.oauth2_proxy_chart_version

#   set = [
#     {
#       name  = "controller.kind"
#       type  = "string"
#       value = var.ingress_nginx_controller_kind
#     },
#   ]

#   depends_on = [kubernetes_namespace_v1.main]
# }
