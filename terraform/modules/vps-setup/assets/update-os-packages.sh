#!/bin/bash

set -o errexit

if ! sudo -n true 2>/dev/null; then
    echo "This script requires sudo privileges. Please run with a user that can use sudo."
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

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
else
    echo "Unsupported OS detected. Please run this script on a Debian/Ubuntu-based system."
    echo "No se pudo detectar el gestor de paquetes."
    exit 1
fi
