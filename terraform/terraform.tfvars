required_packages = [
  "htop",
  "fail2ban",
  "git",
  "gnupg",
  "net-tools",
  "python3-systemd",
  "vim"
]

containerd_version      = "2.1.3"
runc_version            = "1.3.0"
cni_plugins_version     = "1.7.1"
nerdctl_version         = "2.1.3"
sandbox_pause_image_tag = "3.10.1"

kubernetes_version = "1.33"
pod_network_cidr   = "10.244.0.0/16"
cilium_cli_version = "0.18.5"
cilium_version     = "1.18.0"
ipam_mode          = "kubernetes"
enable_hubble      = true
hubble_cli_version = "1.17.5"
hubble_enabled_ui  = true

metal_lb_chart_version = "0.15.2"

ingress_nginx_controller_chart_version           = "4.13.0"
ingress_nginx_controller_kind                    = "DaemonSet"
ingress_nginx_controller_external_traffic_policy = "Local"
