data "aws_iam_policy_document" "harness_ce_lambda" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "harness_ce_lambda" {
  count              = var.enable_optimization ? 1 : 0
  name               = "${var.prefix}HarnessCELambdaExecutionRole"
  path               = "/ce-optimization-service-role/"
  assume_role_policy = data.aws_iam_policy_document.harness_ce_lambda.json
}

data "aws_iam_policy_document" "harness_optimsationlambda" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInsightsPath",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:CreateNetworkAcl",
      "ec2:*",
      "ec2:CreateNetworkAclEntry",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "harness_optimsationlambda" {
  count       = var.enable_optimization ? 1 : 0
  name        = "${var.prefix}HarnessOptimsationLambdaPolicy"
  description = "Policy granting Harness Access to Enable Cost Optimisation"
  policy      = data.aws_iam_policy_document.harness_optimsationlambda.json
}

resource "aws_iam_role_policy_attachment" "harness_ce_lambda_optimsationlambda" {
  count      = var.enable_optimization ? 1 : 0
  role       = aws_iam_role.harness_ce_lambda[0].name
  policy_arn = aws_iam_policy.harness_optimsationlambda[0].arn
}