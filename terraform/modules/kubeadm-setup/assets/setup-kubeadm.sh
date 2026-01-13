#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0 <KUBERNETES_VERSION>"
    exit 1
}

# Validate input parameters
if [ "$#" -eq 0 ]; then
  echo "Error: No Kubernetes version specified."
  usage
fi

# Validate sudo access early
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

KUBERNETES_VERSION="$1"

if command -v apt-get >/dev/null 2>&1; then
    echo "Debian/Ubuntu OS detected."
    echo "Installing required packages..."

    export DEBIAN_FRONTEND=noninteractive

    apt-get --quiet=2 --assume-yes update

    apt-get --quiet=2 --assume-yes --no-install-recommends --no-install-suggests install \
        apt-transport-https \
        ca-certificates \
        curl \
        gpg

    curl --fail --silent --show-error --location \
        https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/Release.key | gpg --dearmor --output /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBERNETES_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list

    apt-get --quiet=2 --assume-yes update

    apt-get --quiet=2 --assume-yes --no-install-recommends --no-install-suggests install \
        kubelet \
        kubeadm \
        kubectl

    apt-mark hold \
        kubelet \
        kubeadm \
        kubectl

    systemctl enable --now kubelet

    apt-get --quiet=2 --assume-yes autoremove
    apt-get --quiet=2 --assume-yes autoclean
    rm --recursive --force /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*

    echo "Required packages installed successfully."

else
    echo "Unsupported OS detected. Please run this script on a Debian/Ubuntu-based system."
    exit 1
fi