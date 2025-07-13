terraform {
  backend "s3" {
    key          = "k8s-vps/terraform.tfstate"
    use_lockfile = true
  }
}
