terraform {
  backend "s3" {
    bucket         = "parlai-be"
    key            = "parlai-be.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}