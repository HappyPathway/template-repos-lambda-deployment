output "lambda_function_arn" {
  description = "ARN of the template automation Lambda function"
  value       = module.template_automation.lambda_function_arn
}

output "lambda_function_name" {
  description = "Name of the template automation Lambda function"
  value       = module.template_automation.lambda_function_name
}

output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = module.template_automation.lambda_role_arn
}
