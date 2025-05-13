#general agent_mgmt
variable "environment" {
  type    = string
  default = "poc"
}

variable "agent_bucket_name" {
  type        = string
  description = "S3 bucket name for agent binaries"
  # USER INPUT: e.g. \"poc-agent-binaries\"
  default     = "poc-agent-binaries"
}

#ingestion
variable "lambda_function_name" {
  description = "PoC ingest Lambda name"
  default     = "poc-ingest-handler"   # USER INPUT
}

variable "api_name" {
  description = "API Gateway name for PoC ingestion"
  default     = "poc-ingestion-api"    # USER INPUT
}

variable "stage_name" {
  description = "API Gateway stage"
  default     = "poc"
}

#dashboards_siem
variable "dashboard_name" {
  description = "Name of the CloudWatch Dashboard"
  type        = string
  default     = "poc-mtd-dashboard"   # USER INPUT if you want another name
}

#security_guardrails
variable "config_rule_name" {
  description = "Name for AWS Config rule (S3 encryption)"
  type        = string
  default     = "poc-s3-encryption-rule"   # USER INPUT
}

variable "cloudtrail_name" {
  description = "Name for the CloudTrail audit trail"
  type        = string
  default     = "poc-mtd-trail"            # USER INPUT
}
