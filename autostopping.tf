# the following policies are not included in the standard CCM enablement CF template
# these are least privilage policies for autostopping based on the target resource type

data "aws_iam_policy_document" "autostopping_base" {
  statement {
    effect = "Allow"

    actions = [
      "acm:ListCertificates",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "route53:ChangeResourceRecordSets",
      "route53:GetHealthCheck",
      "route53:GetHealthCheckStatus",
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
      "tag:GetResources",
      "iam:AddRoleToInstanceProfile",
      "iam:CreateServiceLinkedRole",
      "iam:GetUser",
      "iam:ListInstanceProfiles",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRoles",
      "iam:PassRole",
      "lambda:AddPermission",
      "lambda:CreateCodeSigningConfig",
      "lambda:CreateFunction",
      "lambda:CreateFunctionUrlConfig",
      "lambda:DeleteCodeSigningConfig",
      "lambda:DeleteFunction",
      "lambda:DeleteFunctionCodeSigningConfig",
      "lambda:DeleteFunctionConcurrency",
      "lambda:DeleteFunctionEventInvokeConfig",
      "lambda:DeleteFunctionUrlConfig",
      "lambda:DeleteProvisionedConcurrencyConfig",
      "lambda:GetCodeSigningConfig",
      "lambda:GetFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:GetFunctionConcurrency",
      "lambda:GetFunctionConfiguration",
      "lambda:GetFunctionEventInvokeConfig",
      "lambda:GetFunctionUrlConfig",
      "lambda:GetLayerVersion",
      "lambda:GetLayerVersionPolicy",
      "lambda:GetPolicy",
      "lambda:GetProvisionedConcurrencyConfig",
      "lambda:InvokeAsync",
      "lambda:InvokeFunction",
      "lambda:InvokeFunctionUrl",
      "lambda:ListCodeSigningConfigs",
      "lambda:ListFunctionEventInvokeConfigs",
      "lambda:ListFunctions",
      "lambda:ListFunctionsByCodeSigningConfig",
      "lambda:ListFunctionUrlConfigs",
      "lambda:ListLayers",
      "lambda:ListLayerVersions",
      "lambda:ListProvisionedConcurrencyConfigs",
      "lambda:ListTags",
      "lambda:ListVersionsByFunction",
      "lambda:PublishLayerVersion",
      "lambda:PublishVersion",
      "lambda:PutFunctionCodeSigningConfig",
      "lambda:PutFunctionConcurrency",
      "lambda:PutFunctionEventInvokeConfig",
      "lambda:RemovePermission",
      "lambda:TagResource",
      "lambda:UntagResource",
      "lambda:UpdateCodeSigningConfig",
      "lambda:UpdateEventSourceMapping",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionCodeSigningConfig",
      "lambda:UpdateFunctionConfiguration",
      "lambda:UpdateFunctionEventInvokeConfig",
      "lambda:UpdateFunctionUrlConfig"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autostopping_base" {
  count       = var.enable_autostopping_asg_ecs_rds || var.enable_autostopping_elb || var.enable_autostopping_ec2 ? 1 : 0
  name        = "${var.prefix}HarnessAutostoppingBase"
  description = "Policy granting base Harness Access for autostopping"
  policy      = data.aws_iam_policy_document.autostopping_base.json
}

resource "aws_iam_role_policy_attachment" "autostopping_base" {
  count      = var.enable_autostopping_asg_ecs_rds || var.enable_autostopping_elb || var.enable_autostopping_ec2 ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.autostopping_base[0].arn
}

data "aws_iam_policy_document" "autostopping_asg_ecs_rds" {
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:AttachInstances",
      "autoscaling:AttachLoadBalancers",
      "autoscaling:AttachLoadBalancerTargetGroups",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:DeleteTags",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeTargetHealth",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeInstanceRefreshes",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeLoadBalancers",
      "autoscaling:DescribeLoadBalancerTargetGroups",
      "autoscaling:DescribeTags",
      "autoscaling:DetachInstances",
      "autoscaling:DetachLoadBalancers",
      "autoscaling:DetachLoadBalancerTargetGroups",
      "autoscaling:PutScalingPolicy",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:SetInstanceHealth",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "rds:DescribeDBClusters",
      "rds:DescribeDBInstances",
      "rds:ListTagsForResource",
      "rds:StartDBCluster",
      "rds:StartDBInstance",
      "rds:StopDBCluster",
      "rds:StopDBInstance",
      "ecs:DeleteAttributes",
      "ecs:DescribeCapacityProviders",
      "ecs:DescribeClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskSets",
      "ecs:ListAccountSettings",
      "ecs:ListAttributes",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:ListServices",
      "ecs:ListTagsForResource",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:TagResource",
      "ecs:UntagResource",
      "ecs:UpdateService",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autostopping_asg_ecs_rds" {
  count       = var.enable_autostopping_asg_ecs_rds ? 1 : 0
  name        = "${var.prefix}HarnessAutostoppingASGECSRDSLambda"
  description = "Policy granting Harness Access to ASG, ECS and RDS"
  policy      = data.aws_iam_policy_document.autostopping_asg_ecs_rds.json
}

resource "aws_iam_role_policy_attachment" "autostopping_asg_ecs_rds" {
  count      = var.enable_autostopping_asg_ecs_rds ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.autostopping_asg_ecs_rds[0].arn
}

data "aws_iam_policy_document" "autostopping_ec2" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:AllocateAddress",
      "ec2:AssignIpv6Addresses",
      "ec2:AssignPrivateIpAddresses",
      "ec2:AssociateAddress",
      "ec2:AssociateRouteTable",
      "ec2:AttachNetworkInterface",
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CancelSpotFleetRequests",
      "ec2:CancelSpotInstanceRequests",
      "ec2:CopyImage",
      "ec2:CopySnapshot",
      "ec2:CreateFleet",
      "ec2:CreateImage",
      "ec2:CreateNetworkInterface",
      "ec2:CreatePlacementGroup",
      "ec2:CreatePublicIpv4Pool",
      "ec2:CreateRestoreImageTask",
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
      "ec2:CreateStoreImageTask",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAddressesAttribute",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeCoipPools",
      "ec2:DescribeEgressOnlyInternetGateways",
      "ec2:DescribeExportImageTasks",
      "ec2:DescribeExportTasks",
      "ec2:DescribeFastSnapshotRestores",
      "ec2:DescribeFleetHistory",
      "ec2:DescribeFleetInstances",
      "ec2:DescribeFleets",
      "ec2:DescribeFlowLogs",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeImportImageTasks",
      "ec2:DescribeImportSnapshotTasks",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeIpv6Pools",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeNatGateways",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePlacementGroups",
      "ec2:DescribePublicIpv4Pools",
      "ec2:DescribeRegions",
      "ec2:DescribeScheduledInstances",
      "ec2:DescribeSecurityGroupReferences",
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSnapshotTierStatus",
      "ec2:DescribeSpotFleetInstances",
      "ec2:DescribeSpotFleetRequestHistory",
      "ec2:DescribeSpotFleetRequests",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcClassicLink",
      "ec2:DescribeVpcEndpointConnections",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcEndpointServices",
      "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeVpcs",
      "ec2:DetachNetworkInterface",
      "ec2:DetachVolume",
      "ec2:DisassociateAddress",
      "ec2:EnableVolumeIO",
      "ec2:ExportImage",
      "ec2:GetCapacityReservationUsage",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "ec2:GetLaunchTemplateData",
      "ec2:GetSpotPlacementScores",
      "ec2:GetSubnetCidrReservations",
      "ec2:ImportImage",
      "ec2:ImportInstance",
      "ec2:ImportSnapshot",
      "ec2:ImportVolume",
      "ec2:ListImagesInRecycleBin",
      "ec2:ListSnapshotsInRecycleBin",
      "ec2:ModifyFleet",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyInstancePlacement",
      "ec2:ModifyLaunchTemplate",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:ModifySecurityGroupRules",
      "ec2:ModifySnapshotTier",
      "ec2:ModifySpotFleetRequest",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVolume",
      "ec2:ModifyVolumeAttribute",
      "ec2:MonitorInstances",
      "ec2:RebootInstances",
      "ec2:RegisterImage",
      "ec2:ReleaseAddress",
      "ec2:ReportInstanceStatus",
      "ec2:RequestSpotFleet",
      "ec2:RequestSpotInstances",
      "ec2:ResetAddressAttribute",
      "ec2:ResetImageAttribute",
      "ec2:ResetInstanceAttribute",
      "ec2:ResetNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RunInstances",
      "ec2:SendDiagnosticInterrupt",
      "ec2:SendSpotInstanceInterruptions",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:UnassignIpv6Addresses",
      "ec2:UnmonitorInstances"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autostopping_ec2" {
  count       = var.enable_autostopping_ec2 ? 1 : 0
  name        = "${var.prefix}HarnessAutostoppingEC2"
  description = "Policy granting Harness Access to EC2"
  policy      = data.aws_iam_policy_document.autostopping_ec2.json
}

resource "aws_iam_role_policy_attachment" "autostopping_ec2" {
  count      = var.enable_autostopping_ec2 ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.autostopping_ec2[0].arn
}

data "aws_iam_policy_document" "autostopping_elb" {
  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:AttachLoadBalancerToSubnets",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancerListeners",
      "elasticloadbalancing:CreateLoadBalancerPolicy",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancerListeners",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DetachLoadBalancerFromSubnets",
      "elasticloadbalancing:DisableAvailabilityZonesForLoadBalancer",
      "elasticloadbalancing:EnableAvailabilityZonesForLoadBalancer",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetLoadBalancerListenerSSLCertificate",
      "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
      "elasticloadbalancing:SetRulePriorities",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebAcl"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autostopping_elb" {
  count       = var.enable_autostopping_elb ? 1 : 0
  name        = "${var.prefix}HarnessAutostoppingELB"
  description = "Policy granting Harness Access to ELB"
  policy      = data.aws_iam_policy_document.autostopping_elb.json
}

resource "aws_iam_role_policy_attachment" "autostopping_elb" {
  count      = var.enable_autostopping_elb ? 1 : 0
  role       = aws_iam_role.harness_ce.name
  policy_arn = aws_iam_policy.autostopping_elb[0].arn
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