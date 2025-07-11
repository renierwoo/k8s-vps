# -------------------------------------------------------------------------------------------------
# Update OS and system packages
# -------------------------------------------------------------------------------------------------
resource "terraform_data" "update_os_packages" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = "${file("${path.module}/assets/update-os-packages.sh")}"
  }

  provisioner "file" {
    source      = "${path.module}/assets/update-os-packages.sh"
    destination = "/tmp/update-os-packages.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update-os-packages.sh",
      "sudo /tmp/update-os-packages.sh",
      "sudo rm --force /tmp/update-os-packages.sh"
    ]
  }

  connection {
    type        = var.connection_type
    user        = var.connection_user
    host        = var.connection_host
    port        = var.connection_port
    private_key = var.connection_private_key
  }
}


# -------------------------------------------------------------------------------------------------
# Install required packages
# -------------------------------------------------------------------------------------------------
resource "terraform_data" "install_required_packages" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = "${file("${path.module}/assets/install-required-packages.sh")}"
  }

  provisioner "file" {
    source      = "${path.module}/assets/install-required-packages.sh"
    destination = "/tmp/install-required-packages.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-required-packages.sh",
      "sudo /tmp/install-required-packages.sh",
      "sudo rm --force /tmp/install-required-packages.sh"
    ]
  }

  connection {
    type        = var.connection_type
    user        = var.connection_user
    host        = var.connection_host
    port        = var.connection_port
    private_key = var.connection_private_key
  }

  depends_on = [terraform_data.update_os_packages]
}


# -------------------------------------------------------------------------------------------------
# Uninstall old package versions
# -------------------------------------------------------------------------------------------------
resource "terraform_data" "uninstall_old_package_versions" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = "${file("${path.module}/assets/uninstall-old-package-versions.sh")}"
  }

  provisioner "file" {
    source      = "${path.module}/assets/uninstall-old-package-versions.sh"
    destination = "/tmp/uninstall-old-package-versions.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/uninstall-old-package-versions.sh",
      "sudo /tmp/uninstall-old-package-versions.sh",
      "sudo rm --force /tmp/uninstall-old-package-versions.sh"
    ]
  }

  connection {
    type        = var.connection_type
    user        = var.connection_user
    host        = var.connection_host
    port        = var.connection_port
    private_key = var.connection_private_key
  }

  depends_on = [terraform_data.install_required_packages]
}


# -------------------------------------------------------------------------------------------------
# Setting up container runtime
# -------------------------------------------------------------------------------------------------
resource "terraform_data" "setup_container_runtime" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = "${file("${path.module}/assets/setup-container-runtime.sh")}"
  }

  provisioner "file" {
    source      = "${path.module}/assets/setup-container-runtime.sh"
    destination = "/tmp/setup-container-runtime.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-container-runtime.sh",
      "sudo /tmp/setup-container-runtime.sh",
      "sudo rm --force /tmp/setup-container-runtime.sh"
    ]
  }

  connection {
    type        = var.connection_type
    user        = var.connection_user
    host        = var.connection_host
    port        = var.connection_port
    private_key = var.connection_private_key
  }

  depends_on = [terraform_data.uninstall_old_package_versions]
}
