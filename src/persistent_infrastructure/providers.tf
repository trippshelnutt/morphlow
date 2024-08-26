terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.62"
    }
  }

  backend "s3" {
    bucket = "morphlow-terraform-state"
    key    = "persistent"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}
