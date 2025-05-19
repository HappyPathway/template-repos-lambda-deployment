# Template Repositories Lambda Deployment

## Overview

This repository contains the Terraform code to deploy the Template Automation Lambda function and its supporting AWS resources. It is the entry point for provisioning the automation system.

## System Integration

This repository works together with the following:

1. **terraform-aws-template-automation**: Provides the Terraform modules used here to deploy and manage the Lambda function and related infrastructure.
2. **template-automation-lambda**: The Lambda function code that is deployed and managed by this repository.

This repository provisions the Lambda function, configures IAM, environment variables, and connects all components for automated repository creation.

## Current Deployment

The Lambda function is currently deployed in:
- **AWS Account**: csvd-dev-ew
- **AWS Region**: us-gov-west-1

## System Overview

This repository is part of the template automation system, which consists of four main repositories:

1. **template-repos-lambda-deployment** (This Repository)
   * Contains the Terraform code that deploys the Lambda function
   * Manages IAM roles, permissions, and AWS resources
   * Configures environment variables for the Lambda function

2. **template-automation-lambda** (Lambda Function Code)
   * Contains the Python code that runs in the Lambda function
   * Handles GitHub API interactions through PyGithub
   * Creates new repositories and configures them

3. **terraform-aws-template-automation** (Terraform Modules)
   * Contains reusable Terraform modules for the automation system
   * Used by this lambda-deployment repository

4. **template-eks-cluster** (Template Repository)
   * Template for creating EKS clusters
   * Contains the configuration files and terraform/terragrunt code

## Features

- Automated deployment of the Lambda function to AWS
- Configuration of AWS IAM roles and policies
- Management of API Gateway for Lambda invocation
- Systems Manager Parameter Store for configuration
- Environment variable configuration

## Prerequisites

- AWS credentials with appropriate permissions
- Terraform (version 1.0.0 or higher)
- AWS CLI configured with appropriate access

## Usage

1. Clone this repository:
   ```sh
   git clone <repository-url>
   cd template-repos-lambda-deployment
   ```

2. Update the variables in `varfiles/default.tfvars` or create a new tfvars file for your environment.

3. Initialize Terraform:
   ```sh
   terraform init
   ```

4. Plan the deployment:
   ```sh
   terraform plan -var-file=varfiles/your-environment.tfvars -out=tf.plan
   ```

5. Apply the changes:
   ```sh
   terraform apply tf.plan
   ```

## Configuration Variables

Key variables that need to be configured include:

- `aws_region`: AWS region to deploy resources
- `github_api_url`: URL of the GitHub API
- `github_org_name`: GitHub organization name
- `template_repo_name`: Name of the template repository
- `lambda_config`: Configuration for the Lambda function

See `variables.tf` for a complete list of configuration options.

## Architecture

This Terraform configuration deploys:

1. An AWS Lambda function
2. API Gateway for invoking the Lambda
3. IAM roles and policies
4. Systems Manager parameters
5. CloudWatch log groups

## Contributing

Contributions are welcome! Please feel free to submit a pull request.

## Related Repositories

- [template-automation-lambda](https://github.com/your-org/template-automation-lambda)
- [terraform-aws-template-automation](https://github.com/your-org/terraform-aws-template-automation)
- [template-eks-cluster](https://github.com/your-org/template-eks-cluster)