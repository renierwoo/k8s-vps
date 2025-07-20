#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
    echo "Usage: $0 <CONTAINERD_VERSION> <RUNC_VERSION> <CNI_PLUGINS_VERSION> <NERDCTL_VERSION> <SANDBOX_PAUSE_IMAGE_TAG>"
    exit 1
}

# Validate input parameters
if [ "$#" -eq 0 ]; then
  echo "Error: Missing parameters."
  usage
fi

# Validate sudo access early
if ! sudo --non-interactive true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run as a user with sudo access."
    exit 1
fi

CONTAINERD_VERSION="$1"
RUNC_VERSION="$2"
CNI_PLUGINS_VERSION="$3"
NERDCTL_VERSION="$4"
SANDBOX_PAUSE_IMAGE_TAG="$5"

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

# Download and install containerd
CONTAINERD_TAR=$(mktemp)

curl --fail --silent --show-error --location \
    https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-$ARCHITECTURE.tar.gz \
    --output "$CONTAINERD_TAR"

tar --directory=/usr/local --extract --gzip --verbose --file="$CONTAINERD_TAR"
rm --force "$CONTAINERD_TAR"

# Containerd configuration
mkdir --parents /etc/containerd
containerd config default | tee /etc/containerd/config.toml >/dev/null

# Enable systemd cgroup driver
sed --in-place 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Overriding the sandbox (pause) image
sed --in-place "s#\(sandbox_image = \"registry.k8s.io/pause:\)[^\"]*\"#\1$SANDBOX_PAUSE_IMAGE_TAG\"#" /etc/containerd/config.toml

# Install containerd systemd service
mkdir --parents /usr/local/lib/systemd/system

curl --fail --silent --show-error --location \
    https://raw.githubusercontent.com/containerd/containerd/main/containerd.service \
    --output /usr/local/lib/systemd/system/containerd.service

systemctl daemon-reload
systemctl enable --now containerd

# Download and install runc
RUNC_BIN=$(mktemp)

curl --fail --silent --show-error --location \
    https://github.com/opencontainers/runc/releases/download/v$RUNC_VERSION/runc.$ARCHITECTURE \
    --output "$RUNC_BIN"

install --mode=755 "$RUNC_BIN" /usr/local/sbin/runc
rm --force "$RUNC_BIN"

# Download and install CNI plugins
CNI_TGZ=$(mktemp)

curl --fail --silent --show-error --location \
    https://github.com/containernetworking/plugins/releases/download/v$CNI_PLUGINS_VERSION/cni-plugins-linux-$ARCHITECTURE-v$CNI_PLUGINS_VERSION.tgz \
    --output "$CNI_TGZ"

mkdir --parents /opt/cni/bin
tar --directory=/opt/cni/bin --extract --gzip --verbose --file="$CNI_TGZ"
rm --force "$CNI_TGZ"

# Install nerdctl
NERDCTL_TAR=$(mktemp)

curl --fail --silent --show-error --location \
    https://github.com/containerd/nerdctl/releases/download/v$NERDCTL_VERSION/nerdctl-$NERDCTL_VERSION-linux-$ARCHITECTURE.tar.gz \
    --output "$NERDCTL_TAR"

tar --directory=/usr/local/bin --extract --gzip --verbose --file="$NERDCTL_TAR"
rm --force "$NERDCTL_TAR"

rm --recursive --force /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*
