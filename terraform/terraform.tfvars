required_packages = [
  "htop",
  "fail2ban",
  "git",
  "gnupg",
  "net-tools",
  "python3-systemd",
  "vim"
]

containerd_version      = "2.2.1"
runc_version            = "1.4.0"
cni_plugins_version     = "1.9.0"
nerdctl_version         = "2.2.1"
sandbox_pause_image_tag = "3.10.1"

kubernetes_version = "1.35"
pod_network_cidr   = "10.244.0.0/16"
cilium_cli_version = "0.18.9"
cilium_version     = "1.18.5"
ipam_mode          = "kubernetes"
enable_hubble      = true
hubble_cli_version = "1.18.5"
hubble_enabled_ui  = true

metal_lb_chart_version = "0.15.3"

ingress_nginx_controller_chart_version           = "4.14.1"
ingress_nginx_controller_kind                    = "DaemonSet"
ingress_nginx_controller_external_traffic_policy = "Local"
