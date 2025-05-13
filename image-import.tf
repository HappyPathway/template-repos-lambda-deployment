# Dynamic ECR image management for Lambda function
# Automatically imports the latest image from public ECR repository

# Data source to get the latest available tag from the source registry
module "ecr-clone" {
  source        = "HappyPathway/ecr-clone/aws"
  registry_name = var.project_name
  image_config = [{
    enabled         = true
    dest_path       = null
    name            = "template-automation-lambda"
    source_image    = "h1g9x7n8/template-automation-lambda"
    source_registry = "public.ecr.aws"
    source_tag      = var.image_tag
    tag             = var.image_tag
  }]
  tags = {}
}