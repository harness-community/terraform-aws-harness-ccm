# Terraform AWS Harness CCM

Terraform to configure the CCM module for AWS on Harness.

Can be used as an example or a module:

```terraform
module "ccm" {
  source                = "github.com/harness-community/terraform-aws-harness-ccm.git"
  external_id           = "harness:891928451355:XXXXXXXXXXXXXXX"
  enable_events         = true
  enable_optimization   = true
  enable_governance     = true
  governance_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
```

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
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cur_report_definition.harness_ccm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition) | resource |
| [aws_iam_policy.harness_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_governance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_optimsationlambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.harness_ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.harness_ce_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.harness_ce_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_getrole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_governance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_governance_enforce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_lambda_eventsmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_ce_optimsation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.harness_secret_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.harness_ccm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.harness_ccm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.harness_ccm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.harness_ccm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.harness_ccm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.harness_billingmonitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_ccm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_ce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.harness_ce_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
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
| <a name="input_enable_billing"></a> [enable\_billing](#input\_enable\_billing) | Enable AWS Cost Visibility | `bool` | `true` | no |
| <a name="input_enable_events"></a> [enable\_events](#input\_enable\_events) | Enable AWS Resource Management | `bool` | `false` | no |
| <a name="input_enable_governance"></a> [enable\_governance](#input\_enable\_governance) | Enable AWS Asset Governance | `bool` | `false` | no |
| <a name="input_enable_optimization"></a> [enable\_optimization](#input\_enable\_optimization) | Enable AWS Optimization by Auto-Stopping | `bool` | `false` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID given in the harness UI: harness:891928451355:<guid> | `string` | n/a | yes |
| <a name="input_governance_policy_arn"></a> [governance\_policy\_arn](#input\_governance\_policy\_arn) | Policy arn to give role access to enforce governance | `string` | `""` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A string to add to all resources to add uniqueness | `string` | `""` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | List of secrets that harness should have access to | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_role"></a> [cross\_account\_role](#output\_cross\_account\_role) | n/a |

## References

[Harness CCM AWS Setup Guide](https://docs.harness.io/article/80vbt5jv0q-set-up-cost-visibility-for-aws)

[Harness CCM CloudFormation Template](https://continuous-efficiency-prod.s3.us-east-2.amazonaws.com/setup/ngv1/HarnessAWSTemplate.yaml)
