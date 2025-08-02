resource "terraform_data" "preparation" {
  # Create a trigger replace with a script change
  triggers_replace = {
    script = file("${path.module}/assets/preparation.sh")
  }

  provisioner "file" {
    source      = "${path.module}/assets/preparation.sh"
    destination = "/tmp/preparation.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/preparation.sh",
      "sudo /tmp/preparation.sh",
      "sudo rm --force /tmp/preparation.sh"
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
