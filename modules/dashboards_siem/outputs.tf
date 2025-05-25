output "dashboard_name" {
  description = "CloudWatch Dashboard name"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "dashboard_url" {
  description = "URL to view the dashboard"
  value = format(
    "https://%s.console.aws.amazon.com/cloudwatch/home?region=%s#dashboards:name=%s",
    data.aws_region.current.name,
    data.aws_region.current.name,
    aws_cloudwatch_dashboard.main.dashboard_name
  )
}

output "sns_topic_subscription_id" {
  description = "SNS subscription ID for SOC alerts"
  value       = try(aws_sns_topic_subscription.soc_email[0].id, "")
}
