variable "environment" {
  description = "poc"
  type        = string
}

variable "config_rule_name" {
  description = "Name for the AWS Config rule to enforce S3 encryption"
  type        = string
  # USER INPUT: e.g. "poc-s3-encryption-rule"
}

variable "cloudtrail_name" {
  description = "Name for the CloudTrail audit trail"
  type        = string
  # USER INPUT: e.g. "poc-mtd-trail"
}
