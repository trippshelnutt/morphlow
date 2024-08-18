terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.62"
    }
  }

  backend "s3" {
    bucket = "morphlow-terraform-state"
  }
}


provider "docker" {}


provider "aws" {
  region = var.region
}
