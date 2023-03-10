provider "aws" {
  region = "eu-central-1"
}

resource "aws_apigatewayv2_api" "this" {
  name             = "http-routes-json-test"
  protocol_type    = "HTTP"
  body             = file("petstore.json")
  fail_on_warnings = true
}

resource "aws_apigatewayv2_stage" "v1" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "v1"
  auto_deploy = true

  lifecycle {
    create_before_destroy = true
  }
}

module "this" {
  source                     = "./../../"
  prefix                     = "http-routes-json"
  openapi_definition_content = file("petstore.json")
  openapi_definition_format  = "json"
  create_api_endpoints       = true
  api_gateway_id             = aws_apigatewayv2_api.this.id
  stage                      = aws_apigatewayv2_stage.v1.name
}
