#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0 <SECURE_SSH_PORT>"
    exit 1
}

# Validate sudo access early
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

SECURE_SSH_PORT="$1"

# Rule to deny all incoming traffic
ufw default deny incoming

# Rule to allow all outgoing traffic
ufw default allow outgoing

# Rule to allow SSH connections on the secure port
ufw allow "$SECURE_SSH_PORT"/tcp

# Rule to allow HTTPS connections
ufw allow 443/tcp

# Rule to allow Kubernetes API server connections
ufw allow 6443/tcp

# Rule to allow etcd server client API connections
# ufw allow 2379:2380/tcp

# Rule to allow Kubelet API connections
# ufw allow 10250/tcp

# Rule to allow kube-scheduler connections
# ufw allow 10259/tcp

# Rule to allow kube-controller-manager connections
# ufw allow 10257/tcp

# Rule to allow kube-proxy connections
# ufw allow 10256/tcp

# Rule to allow NodePort Services connections
ufw allow 30000:32767/tcp

# Rule to allow NodePort Services connections
ufw allow 30000:32767/udp

# Rule to allow Calico networking (BGP) connections
# ufw allow 179/tcp

# Rule to allow Calico networking with VXLAN enabled connections
# ufw allow 4789/udp

# Rule to allow Calico networking with Typha enabled connections
# ufw allow 5473/tcp

# Rule to allow Calico networking with IPv4 Wireguard enabled connections
# ufw allow 51820/udp

# Rule to allow Calico networking with IPv6 Wireguard enabled connections
# ufw allow 51821/udp

# Rule to allow MetalLB L2 Operating Mode over tcp connections
# ufw allow 7946/tcp

# Rule to allow MetalLB L2 Operating Mode over udp connections
# ufw allow 7946/udp

echo "Firewall setup completed successfully."
