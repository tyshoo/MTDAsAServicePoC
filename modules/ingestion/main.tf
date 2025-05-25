data "aws_region" "current" {}

################################################
# IAM Role for Lambda - scoped permissions
################################################
resource "aws_iam_role" "lambda_exec" {
  name_prefix = "${var.environment}-${var.lambda_function_name}-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "${var.environment}-${var.lambda_function_name}-policy-"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

################################################
# Lambda Function
################################################
resource "aws_lambda_function" "ingest" {
  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.lambda_exec.arn

  filename         = "${path.module}/stub/handler.zip"
  source_code_hash = filebase64sha256("${path.module}/stub/handler.zip")

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = merge(var.common_tags, {
    Name = var.lambda_function_name
  })
}

################################################
# Lambda Security Group (stub)
################################################
resource "aws_security_group" "lambda_sg" {
  name        = "${var.environment}-lambda-sg"
  description = "Allow outbound to internet via NAT"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

################################################
# API Gateway REST API
################################################
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "PoC ingestion API for ${var.environment}"

  tags = var.common_tags
}

data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  path        = "/"
}

resource "aws_api_gateway_resource" "events" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "events"
}

resource "aws_api_gateway_method" "post_events" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.events.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_events" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.events.id
  http_method             = aws_api_gateway_method.post_events.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ingest.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingest.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api))
  }
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = var.stage_name

  tags = var.common_tags
}

################################################
# WAFv2 WebACL Association (if provided)
################################################
resource "aws_wafv2_web_acl_association" "apigw" {
  count      = var.web_acl_arn != "" ? 1 : 0
  resource_arn = aws_api_gateway_rest_api.api.execution_arn
  web_acl_arn  = var.web_acl_arn
}

################################################
# CloudWatch Alarms on Lambda
################################################
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.environment}-${var.lambda_function_name}-errors"
  alarm_description   = "Alarm on Lambda function errors"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  dimensions = { FunctionName = aws_lambda_function.ingest.function_name }
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  tags                = var.common_tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "${var.environment}-${var.lambda_function_name}-throttles"
  alarm_description   = "Alarm on Lambda function throttles"
  namespace           = "AWS/Lambda"
  metric_name         = "Throttles"
  dimensions = { FunctionName = aws_lambda_function.ingest.function_name }
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  tags                = var.common_tags
}

################################################
# SNS Topic for Alerts
################################################
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-alerts-topic"
  tags = var.common_tags
}
