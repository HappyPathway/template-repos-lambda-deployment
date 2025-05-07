# Dynamic ECR image management for Lambda function
# Automatically imports the latest image from public ECR repository

# Data source to get the latest available tag from the source registry
locals {
  # Create image config with the latest tag
  # public.ecr.aws/h1g9x7n8/template-automation-lambda:0.23.0 
  image_configs = {
    for tag in var.image_tags : tag => {
      enabled         = true
      dest_path       = null
      name            = "template-automation-lambda"
      source_image    = "h1g9x7n8/template-automation-lambda"
      source_registry = "public.ecr.aws"
      source_tag      = tag
      tag             = tag
    }
  }
}

module "ecr-clone" {
  source        = "HappyPathway/ecr-clone/aws"
  for_each      = tomap({ for tag in var.image_tags : tag => lookup(local.image_configs, tag) })
  registry_name = var.project_name
  image_config  = [each.value]
  tags          = {}
}