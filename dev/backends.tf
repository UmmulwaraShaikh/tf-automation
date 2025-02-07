terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "ummu-bucket"
    key    = "tfstate/dev_terraform_tf_state"
    region = "us-east-1"
  }
}

