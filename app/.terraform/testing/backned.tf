terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Terraform   = "true"
      Region      = var.region
      Service     = var.project
      Environment = var.environment
    }
  }
}


#terraform {
#  backend "s3" {
#    bucket               = "my-bucket"
#    key                  = "tfstate"
#    workspace_key_prefix = "app/testing"
#    encrypt              = true
#    region               = "us-east-1"
#  }
#}