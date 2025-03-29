terraform {
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5"
    }
  }
}
