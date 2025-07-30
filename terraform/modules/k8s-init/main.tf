resource "terraform_data" "k8s_init" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/k8s-init.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/k8s-init.sh"
    destination = "/tmp/k8s-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k8s-init.sh",
      "sudo /tmp/k8s-init.sh ${var.pod_network_cidr}",
      "sudo rm --force /tmp/k8s-init.sh"
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
