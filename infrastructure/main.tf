terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "terraform-microk8s-stack-backend"
    key    = "recipes-app-backend-state"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = "terraform-microk8s-stack-backend"
    key    = "backend-state"
    region = "eu-west-2"
  }
}