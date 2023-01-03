terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "> 1"
    }
  }
}

locals {
  prefix = var.prefix == null ? var.api_gateway_id : var.prefix
}
