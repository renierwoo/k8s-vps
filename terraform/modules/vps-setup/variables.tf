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

variable "required_packages" {
  description = "A list of required packages to install on the remote host."
  type        = list(string)
  default     = []
}

variable "containerd_version" {
  description = "The version of containerd to install."
  type        = string
  default     = null
}

variable "runc_version" {
  description = "The version of runc to install."
  type        = string
  default     = null
}

variable "cni_plugins_version" {
  description = "The version of CNI plugins to install."
  type        = string
  default     = null
}

variable "nerdctl_version" {
  description = "The version of nerdctl to install."
  type        = string
  default     = null
}

variable "sandbox_pause_image_tag" {
  description = "The tag of the sandbox pause image to use."
  type        = string
  default     = null
}
