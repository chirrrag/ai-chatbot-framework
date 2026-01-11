terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0.0"
    }
  }
  backend "s3" {
    region         = "ap-south-1"
    bucket         = "ft-infra"
    key            = "terraform/prod/terraform.tfstate"
    dynamodb_table = "ft-infra-terraform"
    encrypt        = true
  }
}

provider "aws" {
  region                   = "ap-south-1"
  shared_credentials_files = ["~/.aws/credentials"]
}