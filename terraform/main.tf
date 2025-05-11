module "vps_setup" {
  source = "./modules/vps_setup"

  connection_user        = var.connection_type
  connection_host        = var.connection_host
  connection_port        = var.connection_port
  connection_private_key = var.connection_private_key
}
