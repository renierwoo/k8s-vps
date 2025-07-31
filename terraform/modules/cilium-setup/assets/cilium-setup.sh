#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0 <CILIUM_CLI_VERSION> <CILIUM_VERSION> <POD_NETWORK_CIDR>"
    exit 1
}

# Validate input parameters
if [ "$#" -eq 0 ]; then
  echo "Error: No arguments provided."
  usage
fi

# Validate sudo access early
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

CILIUM_CLI_VERSION="$1"
CILIUM_VERSION="$2"
POD_NETWORK_CIDR="$3"

# Detect architecture
ARCH=$(uname -m)

if [ -z "$ARCH" ]; then
    echo "Error: Unable to detect architecture."
    exit 1
fi

case "$ARCH" in
    x86_64)
        ARCHITECTURE="amd64"
        ;;
    aarch64|arm64)
        ARCHITECTURE="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH. Only x86_64 and arm64 are supported."
        exit 1
        ;;
esac

echo "Installing Cilium CLI version $CILIUM_CLI_VERSION for architecture $ARCHITECTURE..."

curl --location --fail --remote-name-all \
    https://github.com/cilium/cilium-cli/releases/download/v$CILIUM_CLI_VERSION/cilium-linux-$ARCHITECTURE.tar.gz{,.sha256sum}

sha256sum --check cilium-linux-$ARCHITECTURE.tar.gz.sha256sum

tar --extract --gzip --verbose --file=cilium-linux-$ARCHITECTURE.tar.gz --directory=/usr/local/bin

rm --force cilium-linux-$ARCHITECTURE.tar.gz{,.sha256sum}

echo "Cilium CLI version $CILIUM_CLI_VERSION installed successfully."

echo "Installing Cilium version $CILIUM_VERSION..."

cilium install --version $CILIUM_VERSION --set ipam.operator.clusterPoolIPv4PodCIDRList=$POD_NETWORK_CIDR

echo "Cilium version $CILIUM_VERSION installed successfully."

echo "Removing control-plane node taint..."

kubectl taint nodes $(kubectl get nodes --output='name') node-role.kubernetes.io/control-plane:NoSchedule-

echo "Control-plane node taint removed successfully."
