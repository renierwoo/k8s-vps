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

if command -v apt-get >/dev/null 2>&1; then
    echo "Debian/Ubuntu OS detected."
    echo "Updating OS and system packages..."

    export DEBIAN_FRONTEND=noninteractive

    apt-get --quiet=2 --assume-yes update
    apt-get -o Dpkg::Options::="--force-confold" --quiet=2 --assume-yes upgrade
    apt-get -o Dpkg::Options::="--force-confold" --quiet=2 --assume-yes full-upgrade
    apt-get --quiet=2 --assume-yes autoremove
    apt-get --quiet=2 --assume-yes autoclean
    rm --recursive --force /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*

    echo "OS and system packages updated successfully."

else
    echo "Unsupported OS detected. Please run this script on a Debian/Ubuntu-based system."
    exit 1
fi