output "lambda_function_name" {
  description = "Name of the ingestion Lambda"
  value       = aws_lambda_function.ingest.function_name
}

output "api_invoke_url" {
  description = "URL for POST /events"
  value       = "${aws_api_gateway_stage.stage.invoke_url}${var.stage_name}/events"
}

output "sns_alerts_topic_arn" {
  description = "SNS topic ARN for alarms"
  value       = aws_sns_topic.alerts.arn
}

output "waf_associated" {
  description = "Whether a WAF WebACL was associated"
  value       = var.web_acl_arn != ""
}
