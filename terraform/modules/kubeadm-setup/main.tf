resource "terraform_data" "setup_kubeadm" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/setup-kubeadm.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/setup-kubeadm.sh"
    destination = "/tmp/setup-kubeadm.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup-kubeadm.sh",
      "sudo /tmp/setup-kubeadm.sh ${var.kubernetes_version}",
      "sudo rm --force /tmp/setup-kubeadm.sh"
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
