data "aws_iam_policy_document" "harness_ce" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::891928451355:root"]
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
      "rds:DescribeDBSnapshotAttributes"
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
      aws_s3_bucket.harness_ccm.arn,
      "${aws_s3_bucket.harness_ccm.arn}/*"
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
      "arn:aws:s3:::ce-customer-billing-data-prod*",
      "arn:aws:s3:::ce-customer-billing-data-prod*/*"
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

data "aws_iam_policy_document" "harness_ce_lambda" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [
        var.external_id
      ]
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

resource "aws_iam_role_policy_attachment" "harness_ce_lambda_eventsmonitoring" {
  count      = var.enable_optimization ? 1 : 0
  role       = aws_iam_role.harness_ce_lambda[0].name
  policy_arn = aws_iam_policy.harness_optimsationlambda[0].arn
}

data "aws_iam_policy_document" "harness_optimsation" {
  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:*",
      "ec2:StopInstances",
      "autoscaling:*",
      "ec2:Describe*",
      "iam:CreateServiceLinkedRole",
      "iam:ListInstanceProfiles",
      "iam:ListInstanceProfilesForRole",
      "iam:AddRoleToInstanceProfile",
      "iam:PassRole",
      "ec2:StartInstances",
      "ec2:*",
      "iam:GetUser",
      "ec2:ModifyInstanceAttribute",
      "iam:ListRoles",
      "acm:ListCertificates",
      "lambda:*",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:GetHealthCheck",
      "route53:GetHealthCheckStatus",
      "cloudwatch:GetMetricStatistics",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:ListServices",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:DescribeCapacityProviders",
      "ecs:DescribeClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskSets",
      "ecs:RunTask",
      "ecs:StopTask",
      "ecs:StartTask",
      "ecs:UpdateService",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "rds:ListTagsForResource",
      "rds:AddTagsToResource",
      "rds:RemoveTagsFromResource",
      "rds:ModifyDBInstance",
      "rds:StartDBCluster",
      "rds:StartDBInstance",
      "rds:StopDBCluster",
      "rds:StopDBInstance"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "harness_optimsation" {
  count       = var.enable_optimization ? 1 : 0
  name        = "${var.prefix}HarnessOptimisationPolicy"
  description = "Policy granting Harness Access to Enable Cost Optimisation"
  policy      = data.aws_iam_policy_document.harness_optimsation.json
}

resource "aws_iam_role_policy_attachment" "harness_ce_optimsation" {
  count      = var.enable_optimization ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.harness_optimsation[0].arn
}

data "aws_iam_policy_document" "harness_governance" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:Describe*",
      "ec2:Get*",
      "ec2:ListImagesInRecycleBin",
      "ec2:ListSnapshotsInRecycleBin",
      "elasticbeanstalk:Check*",
      "elasticbeanstalk:Describe*",
      "elasticbeanstalk:List*",
      "elasticbeanstalk:Request*",
      "elasticbeanstalk:Retrieve*",
      "elasticbeanstalk:Validate*",
      "elasticloadbalancing:Describe*",
      "rds:Describe*",
      "rds:Download*",
      "rds:List*",
      "autoscaling-plans:Describe*",
      "autoscaling-plans:GetScalingPlanResourceForecastData",
      "autoscaling:Describe*",
      "autoscaling:GetPredictiveScalingForecast",
      "s3:DescribeJob'",
      "s3:Get*",
      "s3:List*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "harness_governance" {
  count       = var.enable_governance ? 1 : 0
  name        = "${var.prefix}HarnessGovernancePolicy"
  description = "Policy granting Harness Access to Enable Asset Governance"
  policy      = data.aws_iam_policy_document.harness_governance.json
}

resource "aws_iam_role_policy_attachment" "harness_ce_governance" {
  count      = var.enable_governance ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.harness_governance[0].arn
}

resource "aws_iam_role_policy_attachment" "harness_ce_governance_enforce" {
  count      = var.governance_policy_arn != "" ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = var.governance_policy_arn
}