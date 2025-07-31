resource "terraform_data" "cilium_setup" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/cilium-setup.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/cilium-setup.sh"
    destination = "/tmp/cilium-setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cilium-setup.sh",
      "sudo /tmp/cilium-setup.sh ${var.cilium_cli_version} ${var.cilium_version} ${var.ipam_mode} ${var.pod_network_cidr}",
      "sudo rm --force /tmp/cilium-setup.sh"
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
