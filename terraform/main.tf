module "vps_setup" {
  source = "./modules/vps-setup"

  connection_user         = var.connection_user
  connection_host         = var.connection_host
  connection_port         = var.connection_port
  connection_private_key  = var.connection_private_key

  required_packages       = var.required_packages

  containerd_version      = var.containerd_version
  runc_version            = var.runc_version
  cni_plugins_version     = var.cni_plugins_version
  nerdctl_version         = var.nerdctl_version
  sandbox_pause_image_tag = var.sandbox_pause_image_tag
}
