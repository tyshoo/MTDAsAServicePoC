data "aws_region" "current" {}

# Build widgets for Lambda Invocations & Errors
locals {
  lambda_metrics = [
    {
      id     = "invocations"
      label  = "Invocations"
      metric = ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name]
      x      = 0; y = 0; width = 12; height = 6
    },
    {
      id     = "errors"
      label  = "Errors"
      metric = ["AWS/Lambda", "Errors", "FunctionName", var.lambda_function_name]
      x      = 12; y = 0; width = 12; height = 6
    }
  ]

  widgets = [
    for m in local.lambda_metrics : {
      type       = "metric"
      x          = m.x
      y          = m.y
      width      = m.width
      height     = m.height
      properties = {
        metrics = [m.metric]
        period  = 300
        stat    = "Sum"
        region  = data.aws_region.current.name
        title   = m.label
      }
    }
  ]
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name
  dashboard_body = jsonencode({ widgets = local.widgets })
  tags           = var.common_tags
}

# (Optional) SNS subscription stub for alarms
# USER: create subscriptions on this topic for SOC emails
resource "aws_sns_topic_subscription" "soc_email" {
  count      = length(var.sns_topic_arn) > 0 ? 1 : 0
  topic_arn  = var.sns_topic_arn
  protocol   = "email"
  endpoint   = "ops@example.com"  # USER INPUT: SOC email address
}
