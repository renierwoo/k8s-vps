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


resource "digitalocean_kubernetes_cluster" "demo" {
  name   = "demo"
  region = "lon1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

locals {
  rules = {
    first = {
      port = 1000
      type = "ingress"
    },
    second = {
      port = 1000
      type = "egress"
    }
  }
}

resource "aws_security_group_rule" "example" {
  for_each = { for k, v in local.rules : k => v }

  type                     = each.value.type
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.example.id
  source_security_group_id = aws_security_group.example.id
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
}
