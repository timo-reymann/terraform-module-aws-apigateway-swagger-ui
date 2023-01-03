output "lambda_execution_arn" {
  value       = aws_lambda_function.this.invoke_arn
  description = "Execution ARN for the lambda serving the Swagger UI"
}

output "log_group_arn" {
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].arn : null
  description = "ARN of the log group created for the lambda"
}

output "routes" {
  value       = values(local.routes)
  description = "Routes that can/should be served by the Swagger UI lambda. If you set `create_routes` to true, you can ignore this"
}
