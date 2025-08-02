provider "aws" {
  region = var.aws_default_region

  #   default_tags {
  #     tags = var.tags
  #   }
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
