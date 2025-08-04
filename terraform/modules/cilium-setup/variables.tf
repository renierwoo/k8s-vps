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

variable "cilium_cli_version" {
  description = "The version of Cilium CLI to install."
  type        = string
  default     = "0.18.5"
}

variable "cilium_version" {
  description = "The version of Cilium to install."
  type        = string
  default     = "0.18.5"
}

variable "ipam_mode" {
  description = "The IPAM mode to use. Options are 'cluster-pool' or 'kubernetes'."
  type        = string
  default     = "cluster-pool"
}

variable "pod_network_cidr" {
  description = "The CIDR for the pod network."
  type        = string
  default     = "10.244.0.0/16"
}

variable "enable_hubble" {
  description = "Enable Hubble for Cilium. Default is false."
  type        = bool
  default     = false
}

variable "hubble_cli_version" {
  description = "The version of Hubble CLI to install."
  type        = string
  default     = "1.17.5"
}

variable "hubble_enabled_ui" {
  description = "Enable Hubble UI for Cilium. Default is false."
  type        = bool
  default     = false
}

variable "hubble_ui_username" {
  description = "Username for Hubble UI."
  type        = string
  sensitive   = true
  default     = null
}

variable "hubble_ui_password" {
  description = "Password for Hubble UI."
  type        = string
  sensitive   = true
  default     = null
}

variable "hubble_ui_domain" {
  description = "Domain for Hubble UI."
  type        = string
  sensitive   = true
  default     = null
}

variable "main_domain_tls_cert" {
  description = "The certificate for the main domain."
  type        = string
  sensitive   = true
  default     = null
}

variable "main_domain_tls_key" {
  description = "The private key for the main domain certificate."
  type        = string
  sensitive   = true
  default     = null
}
