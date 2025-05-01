variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`))"
  default     = {}
}
