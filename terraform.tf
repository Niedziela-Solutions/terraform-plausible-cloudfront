terraform {
  backend "s3" {
    key    = "plausible-terraform.tfstate"
  }
}

provider "aws" {
  profile = var.profile
  region = var.region
}
