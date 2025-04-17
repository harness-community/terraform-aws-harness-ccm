# Terraform AWS Harness CCM

Terraform to configure your AWS account for use with Harness CCM.

Can be used as a module or a starting point for your own automation.

## Authentication

This module creates AWS resources. To set up authentication to your AWS account please see the [AWS provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

## Usage

### Master Payer Accounts

When creating a role in your master payer account for granting Harness access to your CUR, be sure and set `s3_bucket_arn` to the bucket that holds your CUR and `enable_billing` to true:

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {}

module "ccm-billing" {
  source                = "harness-community/harness-ccm/aws"
  version               = "1.0.0"

  external_id             = "harness:891928451355:<your harness account id>"

  s3_bucket_arn           = "arn:aws:s3:::<s3 bucket name with cur data>"
  enable_billing          = true

  enable_commitment_read  = true
  enable_commitment_write = true
}
```

To enable the commitment orchestrator feature, set `enable_commitment_read` to get visibility on your commitments and `enable_commitment_write` to enable making purchases through Harness.

#### EU Cluster Accounts

If your Harness account is located in our EU cluster, you will need to pass the following inputs:
```
  s3_bucket_name = "harness-ccm-service-data-bucket-prod-eu"
  aws_account_id = "783764615875"
  external_id    = "harness:783764615875:<your harness account id>"
  trusted_roles  = [
    "arn:aws:iam::783764615875:user/harness-ccm-service-user-prod-eu"
  ]
```

### Member Accounts

When creating roles in member accounts, for non billing access, just set the specific features you want to enable:

- enable_events: gather inventory for dashboards and ec2/ecs recommendation data (read only)
- autostopping_loadbalancers: enables access required for leveraging ALB and/or Proxy autostopping
- autostopping_resources: enables access required for autostopping based on target resource types
- enable_governance: grant view-only access to be able to run governance in dry run and create custom recommendations (read only)
- governance_policy_arn: to use governance to make changes, give custom policies that give the access requred (based on the actions you want to take) (write)

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {}

module "ccm-member" {
  source                = "harness-community/harness-ccm/aws"
  version               = "1.0.0"
  
  external_id             = "harness:891928451355:<your harness account id>"

  # for inventory and recommendations
  enable_events           = true

  # enable specific types of autostopping to be used
  autostopping_loadbalancers = ["alb", "proxy"]
  autostopping_resources     = ["ec2", "ec2-spot", "asg", "rds", "ecs"]

  # enable view access for governance dry runs
  enable_governance       = true

  # enable write access for governance enforcements
  governance_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
}
```

#### CMK EBS Volumes

When EBS volumes are encrypted using customer-managed keys using KMS, AutoStopping will not be able to start the instances with just the default permissions. Additional permissions are required to enable KMS decryption. To get KMS encrypted volumes to work with AutoStopping, the following changes must be performed:

- Permissions added to IAM Role to allow `kms` actions
- Tag KMS Keys - Add a `harness.io/allowForAutoStopping:true` tag to the KMS keys

To enable these permissions, set the variable.

## Requirements

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.autostopping_cmk_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.autostopping_loadbalancers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.autostopping_resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_commitment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_optimsationlambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.harness_ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.harness_ce_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.autostopping_cmk_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.autostopping_loadbalancers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.autostopping_resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_commitment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_governance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_governance_enforce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_lambda_optimsationlambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.autostopping_cmk_ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.autostopping_loadbalancers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.autostopping_resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_ce_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_commitment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_optimsationlambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_external\_ids | Additional external ids to allow | `list(string)` | `[]` | no |
| autostopping\_loadbalancers | Load balancers to be used with autostopping | `list(string)` | <pre>[<br/>  "alb",<br/>  "proxy"<br/>]</pre> | no |
| autostopping\_resources | Resources to allow autostopping for | `list(string)` | <pre>[<br/>  "ec2",<br/>  "ec2-spot",<br/>  "asg",<br/>  "rds",<br/>  "ecs"<br/>]</pre> | no |
| aws\_account\_id | Source AWS account ID, this is Harness' AWS account. If using Harness in SMP mode, set your account ID here | `string` | `"891928451355"` | no |
| enable\_billing | Enable AWS Cost Visibility | `bool` | `false` | no |
| enable\_cmk\_ebs | Enable CMK KMS permissions for EBS | `bool` | `false` | no |
| enable\_commitment\_read | Enable AWS Commitment Orchestrator Read | `bool` | `false` | no |
| enable\_commitment\_write | Enable AWS Commitment Orchestrator Write | `bool` | `false` | no |
| enable\_events | Enable AWS Resource Management | `bool` | `false` | no |
| enable\_governance | Enable AWS Asset Governance | `bool` | `false` | no |
| enable\_optimization | Enable AWS Optimization by Auto-Stopping | `bool` | `false` | no |
| external\_id | External ID given in the harness UI: harness:<aws\_account\_id>:<guid> | `string` | n/a | yes |
| governance\_policy\_arns | Policy arns to give role access to enforce governance | `list(string)` | `[]` | no |
| prefix | A string to add to all resources to add uniqueness | `string` | `""` | no |
| s3\_bucket\_arn | S3 Arn for the bucket that holds your CUR | `string` | `""` | no |
| s3\_bucket\_name | S3 bucket name for the bucket that Harness uses to store and analyze your CUR | `string` | `"ce-customer-billing-data-prod"` | no |
| secrets | List of secrets that harness should have access to | `list(string)` | `[]` | no |
| trusted\_roles | Roles allowed to assume the created role. Defaults are listed for accounts based in US Harness clusters (0,1,2,3,4) | `list(string)` | <pre>[<br/>  "arn:aws:iam::891928451355:user/prod-data-pipeline-dont-delete",<br/>  "arn:aws:iam::891928451355:user/ce-prod-bucket-admin"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| cross\_account\_role | n/a |
| external\_id | n/a |

## References

[Harness CCM AWS Setup Guide](https://docs.harness.io/article/80vbt5jv0q-set-up-cost-visibility-for-aws)

[Harness CCM CloudFormation Template](https://continuous-efficiency-prod.s3.us-east-2.amazonaws.com/setup/ngv1/HarnessAWSTemplate.yaml)
