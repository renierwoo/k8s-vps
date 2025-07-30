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

variable "kubernetes_version" {
  description = "The version of Kubernetes to install."
  type        = string
  default     = "1.33"
}
