#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0 <POD_NETWORK_CIDR>"
    exit 1
}

# Validate input parameters
if [ "$#" -eq 0 ]; then
  echo "Error: No pod network CIDR specified."
  usage
fi

# Validate sudo access early
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

POD_NETWORK_CIDR="$1"

kubeadm init --pod-network-cidr="$POD_NETWORK_CIDR"

mkdir --parents $HOME/.kube

cp --force /etc/kubernetes/admin.conf $HOME/.kube/config

chown $(id --user):$(id --group) $HOME/.kube/config

echo "Kubernetes initialized successfully."
