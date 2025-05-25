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

output "security_alerts_sns" {
  description = "SNS topic ARN for security alerts"
  value       = aws_sns_topic.alerts.arn
}

output "config_noncompliant_alarm" {
  description = "CloudWatch Alarm for Config non‑compliance"
  value       = aws_cloudwatch_metric_alarm.config_noncompliant.alarm_name
}
