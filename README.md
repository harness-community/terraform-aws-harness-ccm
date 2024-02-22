# Terraform AWS Harness CCM

Terraform to configure your AWS account for use with Harness CCM.

Can be used as a module or a starting point for your own automation.

## Authentication

This module creates AWS resources. To set up authentication to your AWS account please see the [AWS provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

The examples below also include optional Harness resources `harness_platform_connector_awscc` that show how to create the necessary AWS CCM connectors within Harness. If you wish to use those examples please see the [Harness provider documentation](https://registry.terraform.io/providers/harness/harness/latest/docs) on setting up authentication to Harness for Terraform.

## Usage

### Billing Accounts

When creating a role in your master account for granting Harness access to your CUR, be sure and set `s3_bucket_arn` to the bucket that holds your CUR and `enable_billing` to true:

```terraform
# create aws role
module "ccm-billing" {
  source                = "harness-community/harness-ccm/aws"
  version               = "0.1.4"

  external_id             = "harness:891928451355:randomstringhere"

  s3_bucket_arn           = "arn:aws:s3:::my-cur-bucket"
  enable_billing          = true
}
```

[optional] You can then create the corresponding AWS CCM connector in your Harness account by referencing outputs from the module and using resource from the official Harness provider.

```terraform
# create harness aws ccm connector
resource "harness_platform_connector_awscc" "aws-master" {
  identifier = "awsmaster"
  name       = "aws-master"

  account_id  = "759984737373"
  report_name = "harness-ccm"
  s3_bucket   = "my-cur-bucket"

  features_enabled = [
    "BILLING",
  ]

  cross_account_access {
    role_arn    = module.ccm-billing.cross_account_role
    external_id = module.ccm-billing.external_id
  }
}
```

### Member Accounts

When creating roles in member accounts, for non billing access, just set the specific features you want to enable:

```terraform
module "ccm-member" {
  source                = "harness-community/harness-ccm/aws"
  version               = "0.1.0"
  
  external_id             = "harness:891928451355:XXXXXXXXXXXXXXX"
  enable_events           = true
  enable_optimization     = true
  enable_governance       = true
  governance_policy_arn = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}
```

[optional] You can then create the corresponding AWS CCM connector in your Harness account by referencing outputs from the module and using resource from the official Harness provider.

```terraform
# create harness aws ccm connector
resource "harness_platform_connector_awscc" "aws-member" {
  identifier = "awsmember"
  name       = "aws-member"

  account_id  = "759984737373"
  features_enabled = [
    "OPTIMIZATION",
    "VISIBILITY",
  ]
  cross_account_access {
    role_arn    = module.ccm-member.cross_account_role
    external_id = module.ccm-member.external_id
  }
}
```

## Fine-Grain Permissions

Optionally we have included fine-grain policies for autostopping which list out specific IAM actions needed based on your target resource type.

You can set these with `enable_autostopping_elb`, `enable_autostopping_ec2`, and `enable_autostopping_asg_rds_lambda`

## CMK EBS Volumes

When EBS volumes are encrypted using customer-managed keys using KMS, AutoStopping will not be able to start the instances with just the default permissions. Additional permissions are required to enable KMS decryption. To get KMS encrypted volumes to work with AutoStopping, the following changes must be performed:

- Permissions added to IAM Role to allow `kms` actions
- Tag KMS Keys - Add a `harness.io/allowForAutoStopping:true` tag to the KMS keys

To enable the permissions, set the variable 

## how-to

Log in to [harness](app.harness.io) and navigate to the `Cloud Costs` service. Select `AWS`.

![ccm-aws](./images/ccm_tf_0.png)

Name the connector, and enter your AWS account ID.

![ccm-aws](./images/ccm_tf_1.png)

Enter the name of the usage report and s3 bucket. The defaults in this terraform example are `harness-ccm` and `harness-ccm`. If you are using the prefix variable, add the prefix in front of the default values. Do not create these resources, they will be created by Terraform.

![ccm-aws](./images/ccm_tf_2.png)

You can enable the CCM features you want on this screen (but the features will also be enabled optionally in the terraform example).

![ccm-aws](./images/ccm_tf_3.png)

Copy the `External ID` from the next page, you will need it as an input to the terraform.

![ccm-aws](./images/ccm_tf_4.png)

Copy the code locally, [install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli), set up your AWS credentils, and optionally enable or disable any of the CCM features by editing the `variables.tf` file. If you are using a prefix, make sure the value matches the prefix you specified previously.

![ccm-aws](./images/ccm_tf_vars.png)

Now run a `terraform init`, `terraform apply`, and enter the `External ID` when prompted.

![ccm-aws](./images/ccm_tf_input.png)

When complete the terraform will output an `Cross Account Role ARN`

![ccm-aws](./images/ccm_tf_output.png)

Paste the role arn into the AWS Connector wizard and continue.

![ccm-aws](./images/ccm_tf_5.png)

The next screen will verify you have set up the AWS Connector correctly.

![ccm-aws](./images/ccm_tf_6.png)

To enable features in the future, you can simply change the input varibles and rerun the terraform.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.harness_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_commitment_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_commitment_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_governance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_optimsationlambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.harness_ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.harness_ce_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.harness_ce_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_commitment_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_commitment_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_governance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_governance_enforce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_lambda_optimsationlambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.harness_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_ce_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_commitment_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_commitment_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_governance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_optimsationlambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_external_ids"></a> [additional\_external\_ids](#input\_additional\_external\_ids) | Additional external ids to allow | `list(string)` | `[]` | no |
| <a name="input_enable_billing"></a> [enable\_billing](#input\_enable\_billing) | Enable AWS Cost Visibility | `bool` | `false` | no |
| <a name="input_enable_commitment_read"></a> [enable\_commitment\_read](#input\_enable\_commitment\_read) | Enable AWS Commitment Orchestrator Read | `bool` | `false` | no |
| <a name="input_enable_commitment_write"></a> [enable\_commitment\_write](#input\_enable\_commitment\_write) | Enable AWS Commitment Orchestrator Write | `bool` | `false` | no |
| <a name="input_enable_events"></a> [enable\_events](#input\_enable\_events) | Enable AWS Resource Management | `bool` | `false` | no |
| <a name="input_enable_governance"></a> [enable\_governance](#input\_enable\_governance) | Enable AWS Asset Governance | `bool` | `false` | no |
| <a name="input_enable_optimization"></a> [enable\_optimization](#input\_enable\_optimization) | Enable AWS Optimization by Auto-Stopping | `bool` | `false` | no |
| <a name="input_enable_cmk_ebs"></a> [enable\_cmk\_ebs](#input\_enable\_cmk\_ebs) | Enable CMK KMS permissions for EBS | `bool` | `false` | no |
| <a name="input_enable_autostopping_elb"></a> [enable\_autostopping\_elb](#input\_enable\_autostopping\_elb) | Enable AutoStopping permissions for ELB | `bool` | `false` | no |
| <a name="input_enable_autostopping_ec2"></a> [enable\_autostopping\_ec2](#input\_enable\_autostopping\_ec2) | Enable AutoStopping permissions for EC2 | `bool` | `false` | no |
| <a name="input_enable_autostopping_asg_rds_lambda"></a> [enable\_autostopping\_asg\_rds\_lambda](#input\_enable\_autostopping\_asg\_rds\_lambda) | Enable AutoStopping permissions for ASG, RDS, and Lambda | `bool` | `false` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID given in the harness UI: harness:891928451355:<guid> | `string` | n/a | yes |
| <a name="input_governance_policy_arns"></a> [governance\_policy\_arns](#input\_governance\_policy\_arns) | Policy arns to give role access to enforce governance | `list(string)` | `[]` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A string to add to all resources to add uniqueness | `string` | `""` | no |
| <a name="input_s3_bucket_arn"></a> [s3\_bucket\_arn](#input\_s3\_bucket\_arn) | S3 Arn for the bucket that holds your CUR | `string` | `""` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of secrets that harness should have access to | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_role"></a> [cross\_account\_role](#output\_cross\_account\_role) | n/a |

## References

[Harness CCM AWS Setup Guide](https://docs.harness.io/article/80vbt5jv0q-set-up-cost-visibility-for-aws)

[Harness CCM CloudFormation Template](https://continuous-efficiency-prod.s3.us-east-2.amazonaws.com/setup/ngv1/HarnessAWSTemplate.yaml)
