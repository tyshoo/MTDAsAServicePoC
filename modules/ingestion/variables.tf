variable "environment" {
  description = "poc"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the PoC ingestion Lambda function"
  type        = string
  # USER INPUT: e.g. "poc-ingest-handler"
}

variable "lambda_handler" {
  description = "Lambda handler (file.function) in stub/"
  type        = string
  default     = "handler.handler"
  # USER INPUT: if you rename the stub file or function
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
  description = "Deployment stage name"
  type        = string
  default     = "poc"
}
