provider "aws" {
  region = "eu-central-1"
}

resource "aws_apigatewayv2_api" "this" {
  name             = "http-routes-json-test"
  protocol_type    = "HTTP"
  body             = file("petstore.json")
  fail_on_warnings = true
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true

  lifecycle {
    create_before_destroy = true
  }
}

module "this" {
  source                     = "./../../"
  prefix                     = "http-routes-json"
  openapi_definition_content = file(var.openapi_file)
  openapi_definition_format  = "json"
  create_api_endpoints       = true
  api_gateway_id             = aws_apigatewayv2_api.this.id
}
