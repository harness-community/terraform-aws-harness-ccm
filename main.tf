data "aws_iam_policy_document" "harness_ce" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.trusted_roles
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = concat([var.external_id], var.additional_external_ids)
    }
  }
}

resource "aws_iam_role" "harness_ce" {
  name               = "${var.prefix}HarnessCERole"
  assume_role_policy = data.aws_iam_policy_document.harness_ce.json
}

data "aws_iam_policy_document" "harness_getrole" {
  statement {
    effect = "Allow"

    actions = ["iam:SimulatePrincipalPolicy"]

    resources = [
      aws_iam_role.harness_ce.arn
    ]
  }
}

resource "aws_iam_policy" "harness_getrole" {
  name        = "${var.prefix}HarnessGetRolePolicy"
  description = "Policy granting Harness Simulate Principle Policy"
  policy      = data.aws_iam_policy_document.harness_getrole.json
}

resource "aws_iam_role_policy_attachment" "harness_ce_getrole" {
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.harness_getrole.arn
}

data "aws_iam_policy_document" "harness_eventsmonitoring" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:ListClusters*",
      "ecs:DescribeClusters",
      "ecs:ListServices",
      "ecs:DescribeServices",
      "ecs:DescribeContainerInstances",
      "ecs:ListTasks",
      "ecs:ListContainerInstances",
      "ecs:DescribeTasks",
      "ec2:DescribeInstances*",
      "ec2:DescribeRegions",
      "cloudwatch:GetMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "rds:DescribeDBSnapshots",
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:DescribeDBSnapshotAttributes",
      "ce:GetRightsizingRecommendation"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "harness_eventsmonitoring" {
  count       = var.enable_events ? 1 : 0
  name        = "${var.prefix}HarnessEventsMonitoringPolicy"
  description = "Policy granting Harness Access to Enable Event Collection"
  policy      = data.aws_iam_policy_document.harness_eventsmonitoring.json
}

resource "aws_iam_role_policy_attachment" "harness_ce_eventsmonitoring" {
  count      = var.enable_events ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.harness_eventsmonitoring[0].arn
}

data "aws_iam_policy_document" "harness_billingmonitoring" {
  statement {
    sid = "readBillingBucket"

    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject"
    ]

    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }

  statement {
    sid = "writeHarnessBucket"

    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}*",
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }

  statement {
    sid = "readOrg"

    effect = "Allow"

    actions = [
      "cur:DescribeReportDefinitions",
      "organizations:Describe*",
      "organizations:List*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "harness_billingmonitoring" {
  count       = var.enable_billing ? 1 : 0
  name        = "${var.prefix}HarnessBillingMonitoringPolicy"
  description = "Policy granting Harness Access to Collect Billing Data"
  policy      = data.aws_iam_policy_document.harness_billingmonitoring.json
}

resource "aws_iam_role_policy_attachment" "harness_ce_billingmonitoring" {
  count      = var.enable_billing ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.harness_billingmonitoring[0].arn
}

resource "aws_iam_role_policy_attachment" "harness_ce_governance" {
  count      = var.enable_governance ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "harness_ce_governance_enforce" {
  for_each   = toset(var.governance_policy_arns)
  role       = aws_iam_role.harness_ce.name
  policy_arn = each.key
}

data "aws_iam_policy_document" "harness_commitment" {
  statement {
    effect = "Allow"

    actions = concat(
      var.enable_commitment_read ? [
        "ec2:DescribeReservedInstancesOfferings",
        "ce:GetSavingsPlansUtilization",
        "ce:GetReservationUtilization",
        "ec2:DescribeInstanceTypeOfferings",
        "ce:GetDimensionValues",
        "ce:GetSavingsPlansUtilizationDetails",
        "ec2:DescribeReservedInstances",
        "ce:GetReservationCoverage",
        "ce:GetSavingsPlansCoverage",
        "savingsplans:DescribeSavingsPlans",
        "organizations:DescribeOrganization",
        "ce:GetCostAndUsage",
        "rds:DescribeReservedDBInstancesOfferings",
        "pricing:GetProducts"
      ] : [],
      var.enable_commitment_write ? [
        "ec2:PurchaseReservedInstancesOffering",
        "ec2:GetReservedInstancesExchangeQuote",
        "ec2:DescribeInstanceTypeOfferings",
        "ec2:AcceptReservedInstancesExchangeQuote",
        "ec2:DescribeReservedInstancesModifications",
        "ec2:ModifyReservedInstances",
        "ce:GetCostAndUsage",
        "savingsplans:DescribeSavingsPlansOfferings",
        "savingsplans:CreateSavingsPlan",
        "rds:PurchaseReservedDBInstancesOffering"
      ] : []
    )

    resources = ["*"]
  }
}

resource "aws_iam_policy" "harness_commitment" {
  count       = var.enable_commitment_read || var.enable_commitment_read ? 1 : 0
  name        = "${var.prefix}HarnessCommitmentPolicy"
  description = "Policy granting Harness Access to Enable Commitment Orchestration"
  policy      = data.aws_iam_policy_document.harness_commitment.json
}

resource "aws_iam_role_policy_attachment" "harness_ce_commitment" {
  count      = var.enable_commitment_read || var.enable_commitment_read ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.harness_commitment[0].arn
}

data "aws_iam_policy_document" "harness_secret_access" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = var.secrets
  }
}

resource "aws_iam_policy" "harness_secret_access" {
  count       = length(var.secrets) > 0 ? 1 : 0
  name        = "${var.prefix}HarnessSecretAccessPolicy"
  description = "Policy granting Harness Access to Secrets"
  policy      = data.aws_iam_policy_document.harness_secret_access.json
}

resource "aws_iam_role_policy_attachment" "harness_secret_access" {
  count      = length(var.secrets) > 0 ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.harness_secret_access[0].arn
}
