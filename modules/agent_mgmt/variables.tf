variable "environment" {
  description = "Deployment environment (poc, dev, prod)"
  type        = string
}

variable "agent_bucket_name" {
  description = "S3 bucket name for agent binaries"
  type        = string
  # USER INPUT: e.g. "poc-agent-binaries"
}

variable "common_tags" {
  description = "Map of common tags from the tags module"
  type        = map(string)
}
