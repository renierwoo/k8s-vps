#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0 <CILIUM_VERSION>"
    exit 1
}

# Validate input parameters
if [ "$#" -eq 0 ]; then
  echo "Error: No Cilium CLI version specified."
  usage
fi

# Validate sudo access early
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

CILIUM_VERSION="$1"

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

echo "Installing Cilium CLI version $CILIUM_VERSION for architecture $ARCHITECTURE..."

curl --location --fail --remote-name-all \
    https://github.com/cilium/cilium-cli/releases/download/v$CILIUM_VERSION/cilium-linux-$ARCHITECTURE.tar.gz{,.sha256sum}

sha256sum --check cilium-linux-$ARCHITECTURE.tar.gz.sha256sum

tar --extract --gzip --verbose --file=cilium-linux-$ARCHITECTURE.tar.gz --directory=/usr/local/bin

rm --force cilium-linux-$ARCHITECTURE.tar.gz{,.sha256sum}

echo "Cilium CLI version $CILIUM_VERSION installed successfully."

echo "Installing Cilium version $CILIUM_VERSION..."

cilium install --version $CILIUM_VERSION

echo "Cilium version $CILIUM_VERSION installed successfully."
