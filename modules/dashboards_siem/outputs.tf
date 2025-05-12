output "dashboard_name" {
  description = "CloudWatch Dashboard name"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "dashboard_url" {
  description = "URL to view the dashboard in the console"
  value       = format(
    "https://%s.console.aws.amazon.com/cloudwatch/home?region=%s#dashboards:name=%s",
    data.aws_region.current.name,
    data.aws_region.current.name,
    aws_cloudwatch_dashboard.main.dashboard_name
  )
}
