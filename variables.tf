variable "api_gateway_id" {
  description = "ID of the HTTP API-Gateway"
  type        = string
  default     = null
}

variable "create_api_endpoints" {
  description = "Set this to false to add the endpoints inside your OpenAPI definition or your own terraform code"
  type        = bool
  default     = true
}

variable "prefix" {
  description = "Prefix to append to all resource names created. If not specified the API-Gateway name is used as prefix"
  type        = string
  default     = null
}

variable "enable_swagger_ui_entrypoint" {
  description = "Enable swagger ui top level page to redirect to the swagger ui path allowing you to share a flat link and be consistent with e.g. Spring Boot apps"
  type        = string
  default     = true
}

variable "swagger_ui_entrypoint_path" {
  description = "Entrypoint for swagger ui redirect"
  type        = string
  default     = "/swagger-ui.html"
}

variable "swagger_ui_path" {
  description = "Base path for swagger ui"
  type        = string
  default     = "/swagger-ui"
}

variable "openapi_definition_content" {
  description = "Content of openapi definition"
  type        = string
}

variable "openapi_definition_format" {
  description = "Format of definition"
  type        = string
  default     = "yaml"

  validation {
    condition     = contains(["json", "yaml"], var.openapi_definition_format)
    error_message = "Only 'json' and 'yaml' is supported."
  }
}

variable "create_log_group" {
  description = "Should a log group be created for the lambda"
  type        = string
  default     = true
}

variable "log_group_retention_in_days" {
  description = "Amount of days to keep logs"
  type        = number
  default     = 3
}

variable "kms_key_arn" {
  description = "ARN of the KMS key to use"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to resources created by the module"
  type        = map(string)
  default     = {}
}
