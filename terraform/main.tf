module "vps_setup" {
  source = "./modules/vps-setup"

  connection_user        = var.connection_user
  connection_host        = var.connection_host
  connection_port        = var.connection_port
  connection_private_key = var.connection_private_key

  required_packages = var.required_packages

  containerd_version      = var.containerd_version
  runc_version            = var.runc_version
  cni_plugins_version     = var.cni_plugins_version
  nerdctl_version         = var.nerdctl_version
  sandbox_pause_image_tag = var.sandbox_pause_image_tag
}


module "kubeadm_setup" {
  source = "./modules/kubeadm-setup"

  connection_user        = var.connection_user
  connection_host        = var.connection_host
  connection_port        = var.connection_port
  connection_private_key = var.connection_private_key

  kubernetes_version = var.kubernetes_version

  depends_on = [module.vps_setup]
}


module "k8s_init" {
  source = "./modules/k8s-init"

  connection_user        = var.connection_user
  connection_host        = var.connection_host
  connection_port        = var.connection_port
  connection_private_key = var.connection_private_key

  pod_network_cidr = var.pod_network_cidr

  depends_on = [module.kubeadm_setup]
}


module "cilium_setup" {
  source = "./modules/cilium-setup"

  connection_user        = var.connection_user
  connection_host        = var.connection_host
  connection_port        = var.connection_port
  connection_private_key = var.connection_private_key

  cilium_cli_version = var.cilium_cli_version
  cilium_version     = var.cilium_version
  ipam_mode          = var.ipam_mode
  pod_network_cidr   = var.pod_network_cidr
  enable_hubble      = var.enable_hubble
  hubble_cli_version = var.hubble_cli_version
  hubble_enabled_ui  = var.hubble_enabled_ui

  depends_on = [module.k8s_init]
}


module "metal_lb_setup" {
  source = "./modules/metal-lb-setup"

  connection_user        = var.connection_user
  connection_host        = var.connection_host
  connection_port        = var.connection_port
  connection_private_key = var.connection_private_key

  metal_lb_chart_version = var.metal_lb_chart_version

  depends_on = [module.cilium_setup]
}


module "ingress_nginx_controller" {
  source = "./modules/ingress-nginx-controller"

  ingress_nginx_controller_chart_version           = var.ingress_nginx_controller_chart_version
  ingress_nginx_controller_kind                    = var.ingress_nginx_controller_kind
  ingress_nginx_controller_external_traffic_policy = var.ingress_nginx_controller_external_traffic_policy

  depends_on = [module.metal_lb_setup]
}
