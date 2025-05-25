variable "environment" {
  description = "Deployment environment (poc, dev, prod)"
  type        = string
}

variable "common_tags" {
  description = "Map of common tags from tags module"
  type        = map(string)
}

variable "lambda_function_name" {
  description = "Name of the ingestion Lambda function"
  type        = string
  # USER INPUT: e.g. "poc-ingest-handler"
}

variable "lambda_handler" {
  description = "Lambda handler (file.function) in stub/"
  type        = string
  default     = "handler.handler"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "lambda_memory_size" {
  description = "Lambda memory (MB)"
  type        = number
  default     = 128
}

variable "api_name" {
  description = "Name of the API Gateway REST API"
  type        = string
  # USER INPUT: e.g. "poc-ingestion-api"
}

variable "stage_name" {
  description = "API Gateway stage name"
  type        = string
  default     = "poc"
}

variable "vpc_id" {
  description = "VPC ID for Lambda placement"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Lambda"
  type        = list(string)
}

variable "web_acl_arn" {
  description = "ARN of an existing WAFv2 WebACL to attach"
  type        = string
  default     = ""  # can leave empty to skip
}
