output "agent_bucket_name" {
  description = "Name of the S3 bucket hosting agent binaries"
  value       = aws_s3_bucket.agent_bucket.id
}

output "agent_download_url" {
  description = "S3 URL path for the PoC agent binary"
  # USER ACTION: You may want to generate a presigned URL or configure a bucket policy
  value = "s3://${aws_s3_bucket.agent_bucket.id}/${var.environment}/agent_v0.1.0.bin"
}

output "s3_delete_alarm_name" {
  description = "Name of CloudWatch Alarm on S3 deletes"
  value       = aws_cloudwatch_metric_alarm.s3_delete_alarm.alarm_name
}
