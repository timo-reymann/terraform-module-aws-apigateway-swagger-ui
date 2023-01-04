locals {
  function_name      = "${local.prefix}-swagger-docs"
  runtime            = "nodejs18.x"
  route_serve_prefix = var.stage == "$default" ? "" : "/${var.stage}"
}

#tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "this" {
  function_name = local.function_name
  runtime       = local.runtime
  architectures = [
    "arm64"
  ]
  memory_size = 128
  handler     = "main.handler"

  filename         = "${path.module}/code/dist/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/code/dist/lambda.zip")
  layers = [
    aws_lambda_layer_version.this.arn
  ]

  role = aws_iam_role.this.arn

  environment {
    variables = {
      SWAGGER_UI_PATH                 = "${local.route_serve_prefix}${var.swagger_ui_path}"
      SWAGGER_SPEC_FILE               = local.openapi_definition_filename
      SWAGGER_UI_ENTRYPOINT_ENABLED   = var.enable_swagger_ui_entrypoint
      SWAGGER_UI_ENTRYPOINT           = "${local.route_serve_prefix}${var.swagger_ui_entrypoint_path}"
      SWAGGER_CONFIG_ENDPOINT_ENABLED = var.enable_config_endpoint
      SWAGGER_CONFIG_ENDPOINT_PATH    = "${local.route_serve_prefix}${var.swagger_config_endpoint_path}"
    }
  }

  tracing_config {
    mode = "PassThrough"
  }

  tags = var.tags
}
