output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.template_automation.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = module.template_automation.lambda_function_name
}

output "api_endpoint" {
  description = "The URL of the API Gateway endpoint"
  value       = module.template_automation.api_endpoint
}

output "sample_payload" {
  description = "A sample payload that can be used to test the Lambda function in the AWS Console"
  value       = module.template_automation.sample_payload
}

output "test_function_instructions" {
  description = "Instructions for testing the Lambda function in the AWS Console"
  value       = module.template_automation.test_function_instructions
}

output "json_payload" {
  description = "A JSON-formatted payload string that can be directly copied into the AWS Lambda console"
  value       = module.template_automation.json_payload
}

output aws_cli_invoke_command {
  description = "AWS CLI command to invoke the Lambda function with the sample payload"
  value       = module.template_automation.aws_cli_invoke_command
}