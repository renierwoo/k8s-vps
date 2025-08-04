variable "connection_type" {
  description = "The type of connection to use for the provisioner. Default is ssh."
  type        = string
  default     = "ssh"
}

variable "connection_user" {
  description = "The user to connect to the remote host."
  type        = string
  sensitive   = true
  default     = null
}

variable "connection_host" {
  description = "The host or ip address to connect to the remote host."
  type        = string
  sensitive   = true
  default     = null
}

variable "connection_port" {
  description = "The port to connect to the remote host."
  type        = string
  sensitive   = true
  default     = null
}
variable "connection_private_key" {
  description = "The private key to use for the connection."
  type        = string
  sensitive   = true
  default     = null
}

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
