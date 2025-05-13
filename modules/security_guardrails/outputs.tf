output "config_rule_arn" {
  description = "ARN of the S3 encryption Config rule"
  value       = aws_config_config_rule.s3_encryption.arn
}

output "cloudtrail_name" {
  description = "Name of CloudTrail trail"
  value       = aws_cloudtrail.trail.name
}

output "cloudtrail_bucket" {
  description = "S3 bucket storing CloudTrail logs"
  value       = aws_s3_bucket.trail_bucket.id
}
