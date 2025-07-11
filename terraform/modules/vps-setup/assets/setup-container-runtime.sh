#!/bin/bash

set -o errexit

if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

REQUIRED_PACKAGES=(
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
)

if command -v apt-get >/dev/null 2>&1; then
    echo "Debian/Ubuntu OS detected."
    echo "Setting up container runtime..."

    export DEBIAN_FRONTEND=noninteractive

    apt-get --quiet=2 --assume-yes update
    install --mode=0755 --directory /etc/apt/keyrings
    curl --fail --silent --show-error --location https://download.docker.com/linux/debian/gpg --output /etc/apt/keyrings/docker.asc
    chmod u+r,g+r,o+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get --quiet=2 --assume-yes update

    for package in "${REQUIRED_PACKAGES[@]}"; do
        if apt-get -o Dpkg::Options::="--force-confold" --quiet=2 --assume-yes --no-install-recommends --no-install-suggests install $package; then
            echo "Package ${package} installed successfully."
        else
            echo "Failed to install package ${package}."
        fi
    done

    systemctl enable docker.service
    systemctl enable containerd.service

    apt-get --quiet=2 --assume-yes autoremove
    apt-get --quiet=2 --assume-yes autoclean
    rm --recursive --force /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*

    echo ""

else
    echo "Unsupported OS detected. Please run this script on a Debian/Ubuntu-based system."
    echo "No se pudo detectar el gestor de paquetes."
    exit 1
fi
