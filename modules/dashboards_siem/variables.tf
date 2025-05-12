variable "environment" {
  description = "poc"
  type        = string
}

variable "dashboard_name" {
  description = "Name for the CloudWatch Dashboard"
  type        = string
  # USER INPUT: e.g. "poc-mtd-dashboard"
}

variable "lambda_function_name" {
  description = "Name of the ingestion Lambda to monitor"
  type        = string
  # USER INPUT: must match your ingestion.lambda_function_name
}
