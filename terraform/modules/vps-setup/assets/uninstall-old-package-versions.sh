#!/bin/bash

set -o errexit

if ! sudo -n true 2>/dev/null; then
  echo "This script requires sudo privileges. Please run with a user that can use sudo."
  exit 1
fi

OLD_PACKAGE_VERSIONS=(
  docker.io
  docker-compose
  docker-doc
  podman-docker
  containerd
  runc
)

if command -v apt-get >/dev/null 2>&1; then
  echo "Debian/Ubuntu OS detected."
  echo "Uninstalling old package versions..."

  export DEBIAN_FRONTEND=noninteractive

  apt-get --quiet=2 --assume-yes update

  for package in "${OLD_PACKAGE_VERSIONS[@]}"; do
    if dpkg-query --status $package >/dev/null 2>&1; then
      echo "Package ${package} is already installed."
      echo "Removing package ${package} from the system."
      if apt-get --quiet=2 --assume-yes remove $package; then
        echo "Package ${package} removed successfully."
      else
        echo "Failed to remove package ${package}."
      fi
    else
      echo "Package ${package} is not installed."
    fi
  done

  rm --recursive --force /etc/apt/keyrings/docker.asc
  rm --recursive --force /etc/apt/sources.list.d/docker.list

  apt-get --quiet=2 --assume-yes autoremove
  apt-get --quiet=2 --assume-yes autoclean
  rm --recursive --force /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*

  echo "Old package versions uninstalled successfully"

else
  echo "Unsupported OS detected. Please run this script on a Debian/Ubuntu-based system."
  echo "No se pudo detectar el gestor de paquetes."
  exit 1
fi
