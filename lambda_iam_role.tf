data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${local.function_name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  description        = "IAM role for lambda to generate and serve swagger UI for the API-Gateway ${var.api_gateway_id == null ? "" : var.api_gateway_id}"

  tags = var.tags
}

data "aws_iam_policy_document" "lambda" {
  dynamic "statement" {
    for_each = var.create_log_group ? [1] : []

    content {
      sid = "AllowCloudWatchLogsUsage"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      #tfsec:ignore:aws-iam-no-policy-wildcards
      resources = flatten([for _, v in ["%v:*", "%v:*:*"] : format(v, local.log_group_arn)])
    }
  }

  dynamic "statement" {
    for_each = var.kms_key_arn != null ? [1] : []
    content {
      sid = "AllowKMSKeyUsage"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncryptFrom",
        "kms:ReEncryptTo",
        "kms:GenerateDataKey",
        "kms:GenerateDataKeyPair",
        "kms:GenerateDataKeyPairWithoutPlaintext",
        "kms:GenerateDataKeyWithoutPlaintext",
        "kms:DescribeCustomKeyStores",
        "kms:DescribeKey",
        "kms:ListAliases"
      ]

      resources = [
        var.kms_key_arn
      ]
    }
  }
}

resource "aws_iam_role_policy" "this" {
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.lambda.json
}
