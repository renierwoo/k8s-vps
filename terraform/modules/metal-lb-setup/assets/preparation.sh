#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0"
    exit 1
}

# Validate sudo access early
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

kubectl get configmap kube-proxy --namespace kube-system --output='yaml' | \
sed --expression="s/strictARP: false/strictARP: true/" | \
kubectl apply --filename - --namespace kube-system

kubectl rollout restart daemonset kube-proxy --namespace kube-system

echo "Kube-proxy configuration updated to enable strict ARP."
