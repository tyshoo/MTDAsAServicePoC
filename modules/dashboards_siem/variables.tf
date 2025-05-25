variable "environment" {
  description = "Deployment environment (poc, dev, prod)"
  type        = string
}

variable "common_tags" {
  description = "Map of common tags from tags module"
  type        = map(string)
}

variable "dashboard_name" {
  description = "Name for the CloudWatch Dashboard"
  type        = string
  # USER INPUT: e.g. "poc-mtd-dashboard"
}

variable "lambda_function_name" {
  description = "Name of the ingestion Lambda to monitor"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN for alerts"
  type        = string
}
