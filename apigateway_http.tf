locals {
  # route keys
  routes = merge(local.default_routes, local.entrypoint_route, local.config_route)
  default_routes = {
    resources = {
      method = "GET"
      path   = "${var.swagger_ui_path}/{proxy+}"
    },
    resources_index = {
      method = "GET",
      path   = var.swagger_ui_path
    }
  }
  entrypoint_route = var.enable_swagger_ui_entrypoint ? {
    index_rewrite = {
      method = "GET",
      path   = var.swagger_ui_entrypoint_path
    }
  } : {}
  config_route = var.enable_config_endpoint ? {
    config = {
      method = "GET",
      path   = var.swagger_config_endpoint_path
    }
  } : {}
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.create_api_endpoints ? local.routes : {}

  api_id    = var.api_gateway_id
  route_key = "${each.value.method} ${each.value.path}"
  target    = "integrations/${aws_apigatewayv2_integration.this[0].id}"
}

resource "aws_apigatewayv2_integration" "this" {
  count = var.create_api_endpoints ? 1 : 0

  api_id             = var.api_gateway_id
  description        = "Lambda to generate and serve swagger ui"
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.this.invoke_arn
}

data "aws_region" "current" {}

resource "aws_lambda_permission" "apigateway" {
  count = var.create_api_endpoints ? 1 : 0

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.this.account_id}:${var.api_gateway_id}/*/*"
  function_name = aws_lambda_function.this.function_name
}
