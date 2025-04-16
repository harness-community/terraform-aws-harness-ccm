locals {
  autostopping_actions = {
    alb = [
      "acm:ListCertificates",
      "ec2:DescribeVpcs",
      "ec2:DescribeSecurityGroups",
      "elasticloadbalancing:DescribeLoadBalancers",
      "iam:ListRoles",
      "ec2:DescribeSubnets",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:AddTags",
      "lambda:GetFunction",
      "lambda:CreateFunction",
      "iam:PassRole",
      "lambda:AddPermission",
      "elasticloadbalancing:RegisterTargets",
      "lambda:DeleteFunction",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:SetRulePriorities",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyRule",
      "cloudwatch:GetMetricStatistics",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    proxy = [
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeKeyPairs",
      "ec2:RunInstances",
      "secretsmanager:GetSecretValue",
      "ec2:AllocateAddress",
      "ec2:DescribeVpcs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:TerminateInstances",
      "ec2:DescribeImages",
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",
      "ec2:ModifyInstanceAttribute"
    ],
    ec2 = [
      "ec2:DescribeInstances",
      "ec2:CreateTags",
      "ec2:StartInstances",
      "ec2:StopInstances"
    ],
    ec2-spot = [
      "ec2:DescribeVolumes",
      "ec2:CreateImage",
      "ec2:DescribeImages",
      "ec2:TerminateInstances",
      "ec2:DeregisterImage",
      "ec2:DeleteSnapshot",
      "ec2:RequestSpotInstances",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeAddresses",
      "ec2:RunInstances"
    ],
    asg = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:UpdateAutoScalingGroup",
      "ec2:DescribeSpotPriceHistory"
    ],
    rds = [
      "rds:DescribeDBInstances",
      "rds:DescribeDBClusters",
      "rds:ListTagsForResource",
      "rds:StartDBInstance",
      "rds:StartDBCluster",
      "rds:StopDBInstance",
      "rds:StopDBCluster"
    ],
    ecs = [
      "ecs:ListClusters",
      "tag:GetResources",
      "ecs:ListServices",
      "ecs:ListTasks",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks"
    ]
  }
}

data "aws_iam_policy_document" "autostopping_loadbalancers" {
  count = length(var.autostopping_loadbalancers) > 0 ? 1 : 0
  dynamic "statement" {
    for_each = var.autostopping_loadbalancers
    content {
      sid       = each.key
      effect    = "Allow"
      actions   = local.autostopping_actions[each.key]
      resources = ["*"]
    }
  }
}

resource "aws_iam_policy" "autostopping_loadbalancers" {
  count       = length(var.autostopping_loadbalancers) > 0 ? 1 : 0
  name        = "${var.prefix}HarnessAutostoppingLoadBalancers"
  description = "Policy granting Harness Access to create load balancers"
  policy      = data.aws_iam_policy_document.autostopping_loadbalancers[0].json
}

resource "aws_iam_role_policy_attachment" "autostopping_loadbalancers" {
  count      = length(var.autostopping_loadbalancers) > 0 ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.autostopping_loadbalancers[0].arn
}

data "aws_iam_policy_document" "autostopping_resources" {
  count = length(var.autostopping_resources) > 0 ? 1 : 0
  dynamic "statement" {
    for_each = var.autostopping_resources
    content {
      sid       = each.key
      effect    = "Allow"
      actions   = local.autostopping_actions[each.key]
      resources = ["*"]
    }
  }
}

resource "aws_iam_policy" "autostopping_resources" {
  count       = length(var.autostopping_resources) > 0 ? 1 : 0
  name        = "${var.prefix}HarnessAutostoppingResources"
  description = "Policy granting Harness Access to autostop resources"
  policy      = data.aws_iam_policy_document.autostopping_resources[0].json
}

resource "aws_iam_role_policy_attachment" "autostopping_resources" {
  count      = length(var.autostopping_resources) > 0 ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.autostopping_resources[0].arn
}

data "aws_iam_policy_document" "autostopping_cmk_ebs" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:RetireGrant",
      "kms:CreateGrant",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/harness.io/allowForAutoStopping"
      values = [
        "true"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "ec2.us-west-2.amazonaws.com",
        "rds.us-west-2.amazonaws.com",
        "ecs.us-east-2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "autostopping_cmk_ebs" {
  count       = var.enable_cmk_ebs ? 1 : 0
  name        = "${var.prefix}HarnessAutostoppingCMKEBS"
  description = "Policy granting Harness Access to CMK for EBS"
  policy      = data.aws_iam_policy_document.autostopping_cmk_ebs.json
}

resource "aws_iam_role_policy_attachment" "autostopping_cmk_ebs" {
  count      = var.enable_cmk_ebs ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.autostopping_cmk_ebs[0].arn
}