# Construct widget definitions for Invocations and Errors
locals {
  lambda_metrics = [
    {
      id        = "invocations"
      label     = "Invocations"
      metric    = ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name]
      y         = 0
      x         = 0
      width     = 12
      height    = 6
    },
    {
      id        = "errors"
      label     = "Errors"
      metric    = ["AWS/Lambda", "Errors", "FunctionName", var.lambda_function_name]
      y         = 0
      x         = 12
      width     = 12
      height    = 6
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
        region  = "${data.aws_region.current.name}"
        title   = m.label
      }
    }
  ]
}

data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = var.dashboard_name  # USER INPUT
  dashboard_body = jsonencode({
    widgets = local.widgets
  })
}
