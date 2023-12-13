terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["~/.aws/conf"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "iaacproject"
}