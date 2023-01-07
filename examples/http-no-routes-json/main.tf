provider "aws" {
  region = "eu-central-1"
}

module "this" {
  source                     = "./../../"
  prefix                     = "http-no-routes-json"
  openapi_definition_content = file("petstore.yml")
  openapi_definition_format  = "yaml"
  create_api_endpoints       = false
}
