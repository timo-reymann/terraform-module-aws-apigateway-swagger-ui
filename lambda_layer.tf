locals {
  openapi_definition_filename = "openapi.${var.openapi_definition_format}"
}

data "archive_file" "layer" {
  type        = "zip"
  output_path = "${path.module}/.terraform/dist/layer.zip"

  source {
    content  = <<JAVASCRIPT
const fs = require("fs")
const path = require("path")

module.exports = apiSpecFileName => fs.readFileSync(path.join(__dirname, apiSpecFileName), "utf8")
JAVASCRIPT
    filename = "nodejs/node_modules/internal-apigateway-swagger/index.js"
  }

  source {
    content  = var.openapi_definition_content
    filename = "nodejs/node_modules/internal-apigateway-swagger/${local.openapi_definition_filename}"
  }
}

resource "aws_lambda_layer_version" "this" {
  layer_name = "${local.function_name}-openapi-definition"
  compatible_runtimes = [
    local.runtime
  ]

  filename         = data.archive_file.layer.output_path
  source_code_hash = data.archive_file.layer.output_base64sha256
}
