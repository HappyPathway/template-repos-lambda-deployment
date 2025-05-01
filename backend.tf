terraform {
  backend "s3" {
    key = "template-repos-lambda-deployment/terraform.tfstate"
    bucket = "roknsound-terraform-state"
    region = "us-east-1"
  }
}
