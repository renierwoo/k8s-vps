variable "aws_default_region" {
  description = "The AWS default region to use."
  type        = string
  sensitive   = true
}

variable "connection_user" {
  description = "The user to connect to the remote host."
  type        = string
  sensitive   = true
}

variable "connection_host" {
  description = "The host or ip address to connect to the remote host."
  type        = string
  sensitive   = true
}

variable "connection_port" {
  description = "The port to connect to the remote host."
  type        = string
  sensitive   = true
}
variable "connection_private_key" {
  description = "The private key to use for the connection."
  type        = string
  sensitive   = true
}

variable "required_packages" {
  description = "A list of required packages to install on the remote host."
  type        = list(string)
}

variable "containerd_version" {
  description = "The version of containerd to install."
  type        = string
}

variable "runc_version" {
  description = "The version of runc to install."
  type        = string
}

variable "cni_plugins_version" {
  description = "The version of CNI plugins to install."
  type        = string
}

variable "nerdctl_version" {
  description = "The version of nerdctl to install."
  type        = string
}

variable "sandbox_pause_image_tag" {
  description = "The tag of the sandbox pause image to use."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to install."
  type        = string
}

variable "pod_network_cidr" {
  description = "The CIDR for the pod network."
  type        = string
}

variable "cilium_cli_version" {
  description = "The version of Cilium CLI to install."
  type        = string
}

variable "cilium_version" {
  description = "The version of Cilium to install."
  type        = string
}

variable "ipam_mode" {
  description = "The IPAM mode to use. Options are 'cluster-pool' or 'kubernetes'."
  type        = string
}

variable "enable_hubble" {
  description = "Enable Hubble for Cilium. Default is false."
  type        = bool
}

variable "hubble_cli_version" {
  description = "The version of Hubble CLI to install."
  type        = string
}

variable "hubble_enabled_ui" {
  description = "Enable Hubble UI for Cilium. Default is false."
  type        = bool
}

variable "metal_lb_chart_version" {
  description = "The version of the MetalLB Helm chart to install."
  type        = string
}
