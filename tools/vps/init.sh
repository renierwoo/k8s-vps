#!/bin/bash

set -o errexit

if [[ -z "${VPS_USER}" || -z "${VPS_PASSWORD}" || -z "${VPS_HOST}" || -z "${VPS_PORT}" || -z "${VPS_PUBLIC_SSH_KEY}" || -z "${VPS_SECURE_SSH_PORT}" || -z "${IAC_USER}" ]]; then
  echo "Environment variables VPS_USER, VPS_PASSWORD, VPS_HOST, VPS_PORT, VPS_PUBLIC_SSH_KEY, and IAC_USER must be set."
  exit 1
fi

sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no -p "$VPS_PORT" "${VPS_USER}@${VPS_HOST}" <<EOF
  apt-get --quiet=2 --assume-yes update
  apt-get --quiet=2 --assume-yes --no-install-recommends --no-install-suggests install sudo ufw
  adduser --disabled-password --gecos '' $IAC_USER
  usermod -aG sudo $IAC_USER
  echo "$IAC_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$IAC_USER
  mkdir -p /home/$IAC_USER/.ssh
  echo "$VPS_PUBLIC_SSH_KEY" > /home/$IAC_USER/.ssh/authorized_keys
  chown -R $IAC_USER:$IAC_USER /home/$IAC_USER/.ssh
  chmod 700 /home/$IAC_USER/.ssh
  chmod 600 /home/$IAC_USER/.ssh/authorized_keys
  sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
  sed -i 's/^PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sed -i "s/^#Port 22/Port $VPS_SECURE_SSH_PORT/" /etc/ssh/sshd_config
  ufw allow $VPS_SECURE_SSH_PORT/tcp
  ufw delete allow OpenSSH
  ufw delete allow 22/tcp
  echo y | ufw enable
  systemctl restart ssh
EOF
