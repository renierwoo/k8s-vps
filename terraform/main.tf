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
