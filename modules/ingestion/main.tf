# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "${var.environment}-${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Attach basic execution policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function stub
resource "aws_lambda_function" "ingest" {
  function_name = var.lambda_function_name      # USER INPUT
  handler       = var.lambda_handler            # USER INPUT
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory_size
  role          = aws_iam_role.lambda_exec.arn

  filename         = "${path.module}/stub/handler.zip"  # USER: package your stub into this zip
  source_code_hash = filebase64sha256("${path.module}/stub/handler.zip")
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name   # USER INPUT
  description = "PoC ingestion API for ${var.environment}"
}

# Root resource ID
data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  path        = "/"
}

# /events resource
resource "aws_api_gateway_resource" "events" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "events"
}

# POST method on /events
resource "aws_api_gateway_method" "post_events" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.events.id
  http_method   = "POST"
  authorization = "NONE"  # Phase1 PoC; later replace with API Key or Cognito
}

# Integration: POST → Lambda invoke
resource "aws_api_gateway_integration" "post_events" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.events.id
  http_method = aws_api_gateway_method.post_events.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ingest.invoke_arn
}

# Grant API GW permission to invoke Lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingest.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Deployment & Stage
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  # Force new deployment on every change
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api))
  }
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
  stage_name    = var.stage_name   # USER INPUT
}
