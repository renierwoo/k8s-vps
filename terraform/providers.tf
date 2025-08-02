provider "aws" {
  region = var.aws_default_region

  #   default_tags {
  #     tags = var.tags
  #   }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
