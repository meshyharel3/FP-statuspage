provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key  
  secret_key = var.aws_secret_key  
}

# ACM Certificate
module "acm_certificate" {
  source      = "./acm"  # Ensure this is referencing the correct directory
  domain_name = var.domain_name  # Pass the domain_name variable
}

# IAM Permissions for DNS validation in Route 53
module "acm_iam" {
  source = "./iam"  # Ensure this is referencing the correct directory
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

