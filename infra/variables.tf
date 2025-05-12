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
