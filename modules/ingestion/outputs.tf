output "lambda_function_name" {
  description = "Name of ingestion Lambda"
  value       = aws_lambda_function.ingest.function_name
}

output "api_invoke_url" {
  description = "Invocation URL for the POST /events endpoint"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}${var.stage_name}/events"
}
