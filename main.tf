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
    secret_name = "/eks-cluster-deployment/github_token"
    kms_key_id  = aws_kms_key.lambda_secrets_key.arn # Reference to the KMS key for secrets
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
      LOG_LEVEL          = "INFO"
      GITHUB_API         = "https://github.e.it.census.gov" # "https://${data.dns_a_record_set.github.addrs[0]}"
      GITHUB_ORG_NAME    = "SCT-Engineering"
      TEMPLATE_REPO_NAME = "template-eks-cluster"
      PYTHONWARNINGS     = "ignore:Unverified HTTPS request"
      REQUESTS_CA_BUNDLE = "/tmp"  # Using an invalid path forces requests to skip verification
      SSL_CERT_FILE      = "/tmp"  # Force Python's ssl module to skip verification
      GIT_SSL_NO_VERIFY  = "true"  # Also helps with some GitHub clients
      VERIFY_SSL         = "false" # Explicitly disable SSL verification for our custom logic
    }
    vpc_config = {
      subnet_ids         = ["subnet-0b1992a84536c581b"]
      security_group_ids = ["sg-0641c697588b9aa6b"]
    }
  }

  # SSM Parameter configuration
  parameter_store_prefix = "/template-automation"
  ssm_parameters = {
    "github_org"     = "SCT-Engineering"
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
    aws_kms_key.lambda_secrets_key,
  ]
}

# Create a KMS key for Lambda secrets
resource "aws_kms_key" "lambda_secrets_key" {
  description             = "KMS key for Lambda secrets encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "template-repos-lambda-secrets-key"
    Environment = "production"
    Project     = "template-automation"
    ManagedBy   = "terraform"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Lambda to use the key"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
        ]
        Resource = "*"
      }
    ]
  })
}

# Create a KMS alias for easier reference
resource "aws_kms_alias" "lambda_secrets_alias" {
  name          = "alias/template-repos-lambda-secrets"
  target_key_id = aws_kms_key.lambda_secrets_key.key_id
}

resource "aws_iam_role_policy" "lambda_kms_policy" {
  name = "template-repos-lambda-kms-policy"
  role = module.template_automation.lambda_role_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*" // You can restrict this to specific KMS keys if needed
      }
    ]
  })
}
