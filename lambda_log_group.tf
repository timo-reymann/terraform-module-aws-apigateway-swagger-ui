locals {
  log_group_name = "/aws/lambda/${local.function_name}"
  log_group_arn  = format("arn:%s:logs:%s:%s:log-group", data.aws_partition.this.id, data.aws_region.this.name, data.aws_caller_identity.this.id)
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_log_group ? 1 : 0
  name              = local.log_group_name
  retention_in_days = var.log_group_retention_in_days
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}
