variable "ingress_nginx_controller_chart_version" {
  description = "The version of the Ingress NGINX Controller Helm chart to use."
  type        = string
  default     = "4.13.0"
}

variable "ingress_nginx_controller_kind" {
  description = "The kind of the Ingress NGINX Controller. Default is Deployment."
  type        = string
  default     = "Deployment"
}

variable "ingress_nginx_controller_external_traffic_policy" {
  description = "The external traffic policy for the Ingress NGINX Controller."
  type        = string
  default     = null
}

variable "ingress_nginx_controller_metrics_enabled" {
  description = "Enable metrics for the Ingress NGINX Controller."
  type        = bool
  default     = false
}
