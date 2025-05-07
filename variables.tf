variable image_tags {
  description = "List of image tags to be used for the Lambda function"
  type        = list(string)
  default     = ["0.23.0"]
}

variable image_tag {
  description = "Tag for the ECR image"
  type        = string
  default     = "0.23.0"
}

variable image_name {
  description = "Name of the ECR image"
  type        = string
  default     = "template-automation-lambda"
}

variable project_name {
  description = "Project name for the ECR image"
  type        = string
  default     = "eks-automation-lambda"
}