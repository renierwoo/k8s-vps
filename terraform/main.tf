module "vps_setup" {
  source = "./modules/vps-setup"

  connection_user        = var.connection_user
  connection_host        = var.connection_host
  connection_port        = var.connection_port
  connection_private_key = var.connection_private_key
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
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
