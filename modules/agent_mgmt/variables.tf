variable "environment" {
  description = "PoC Environment (Free-tier)"
  type        = string
}

variable "agent_bucket_name" {
  description = "<<Insert Name for S3 bucket hosting agent binaries>>"
  type        = string
}
