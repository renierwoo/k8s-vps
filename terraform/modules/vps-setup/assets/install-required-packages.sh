#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

usage() {
  echo "Usage: $0 <package1> [package2 ... packageN]"
  exit 1
}

# Validate input parameters
if [ "$#" -eq 0 ]; then
  echo "Error: No packages specified."
  usage
fi

# Validate sudo access early
if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
    echo "Debian/Ubuntu OS detected."
    echo "Installing required packages..."

    export DEBIAN_FRONTEND=noninteractive

    apt-get --quiet=2 --assume-yes update

    for package in "$@"; do
        if apt-get -o Dpkg::Options::="--force-confold" --quiet=2 --assume-yes --no-install-recommends --no-install-suggests install $package; then
            echo "Package ${package} installed successfully."
        else
            echo "Failed to install package ${package}."
        fi
    done

    apt-get --quiet=2 --assume-yes autoremove
    apt-get --quiet=2 --assume-yes autoclean
    rm --recursive --force /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*

    echo "Required packages installed successfully."

else
    echo "Unsupported OS detected. Please run this script on a Debian/Ubuntu-based system."
    exit 1
fi
