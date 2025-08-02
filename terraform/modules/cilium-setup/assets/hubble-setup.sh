#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0 <HUBBLE_CLI_VERSION> <ENABLE_HUBBLE_UI>"
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

HUBBLE_CLI_VERSION="$1"
ENABLE_HUBBLE_UI="$2"

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

echo "Installing Hubble CLI version $HUBBLE_CLI_VERSION for architecture $ARCHITECTURE..."

curl --location --fail --remote-name-all \
    https://github.com/cilium/hubble/releases/download/v$HUBBLE_CLI_VERSION/hubble-linux-$ARCHITECTURE.tar.gz{,.sha256sum}

sha256sum --check hubble-linux-$ARCHITECTURE.tar.gz.sha256sum

tar --extract --gzip --verbose --file=hubble-linux-$ARCHITECTURE.tar.gz --directory=/usr/local/bin

rm --force hubble-linux-$ARCHITECTURE.tar.gz{,.sha256sum}

echo "Hubble CLI version $HUBBLE_CLI_VERSION installed successfully."

if [ "$ENABLE_HUBBLE_UI" = "true" ]; then
    echo "Installing Hubble with UI..."
    cilium hubble enable --ui
else
    echo "Installing Hubble without UI..."
    cilium hubble enable
fi

echo "Hubble installed successfully."
