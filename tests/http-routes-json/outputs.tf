output "invoke_url" {
  value       = aws_apigatewayv2_api.this.api_endpoint
  description = "The invoke URL of the API"
}
