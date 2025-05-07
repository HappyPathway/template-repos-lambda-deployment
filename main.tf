module "template_automation" {
  source = "../terraform-aws-template-automation"

  name_prefix     = "template-repos"
  github_org_name = "sct-engineering" # Your GitHub org name

  # Template repository configuration
  template_repo_name = "template-eks-cluster"
  template_topics    = "infrastructure,eks,kubernetes"

  # GitHub configuration
  github_api_url             = "https://github.e.it.census.gov/api/v3" # GitHub Enterprise API URL
  github_commit_author_name  = "Template Automation Bot"
  github_commit_author_email = "automation@census.gov"

  # GitHub token configuration (using AWS Secrets Manager)
  github_token = {
    secret_name = "github/template-automation-token"
  }

  # Lambda function configuration
  lambda_config = {
    image_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.project_name}/${var.image_name}:${var.image_tag}"
    image_config = {
      command = ["app.lambda_handler"]
    }
    memory_size = 512
    timeout     = 300
    environment_variables = {
      LOG_LEVEL = "INFO"
    }
  }

  # SSM Parameter configuration
  parameter_store_prefix = "/template-automation"
  ssm_parameters = {
    "github_org"     = "sct-engineering"
    "template_repo"  = "template-eks-cluster"
    "config_file"    = "config.json"
    "default_branch" = "main"
    "init_branch"    = "init-cluster"
  }

  # Tags
  tags = {
    Environment = "production"
    Project     = "template-automation"
    ManagedBy   = "terraform"
  }

  depends_on = [
    module.ecr-clone,
  ]
}
