# -------------------------------------------------------------------------------------------------
# Update OS and system packages
# -------------------------------------------------------------------------------------------------
resource "terraform_data" "update_os_packages" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/update-os-packages.sh")
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
    script = file("${path.module}/assets/install-required-packages.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/install-required-packages.sh"
    destination = "/tmp/install-required-packages.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-required-packages.sh",
      "sudo /tmp/install-required-packages.sh ${join(" ", var.required_packages)}",
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
# Setting up container runtime
# -------------------------------------------------------------------------------------------------
resource "terraform_data" "setup_container_runtime" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/setup-container-runtime.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/setup-container-runtime.sh"
    destination = "/tmp/setup-container-runtime.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-container-runtime.sh",
      "sudo /tmp/setup-container-runtime.sh ${var.containerd_version} ${var.runc_version} ${var.cni_plugins_version} ${var.nerdctl_version} ${var.sandbox_pause_image_tag}",
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

  # depends_on = [terraform_data.uninstall_old_package_versions]
  depends_on = [terraform_data.install_required_packages]
}
