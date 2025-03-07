variable "s3_bucket_arn" {
  type        = string
  description = "S3 Arn for the bucket that holds your CUR"
  default     = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket name for the bucket that Harness uses to store and analyze your CUR"
  type        = string
  default     = "ce-customer-billing-data-prod"
}

variable "aws_account_id" {
  description = "Source AWS account ID, this is Harness' AWS account. If using Harness in SMP mode, set your account ID here"
  type        = string
  default     = "891928451355"
}

variable "trusted_roles" {
  type        = list(string)
  description = "Roles allowed to assume the created role. Defaults are listed for accounts based in US Harness clusters (0,1,2,3,4)"
  default = [
    "arn:aws:iam::891928451355:user/prod-data-pipeline-dont-delete",
    "arn:aws:iam::891928451355:user/ce-prod-bucket-admin"
  ]
}

variable "external_id" {
  type        = string
  description = "External ID given in the harness UI: harness:<aws_account_id>:<guid>"
}

variable "enable_billing" {
  type        = bool
  default     = false
  description = "Enable AWS Cost Visibility"
}

variable "enable_events" {
  type        = bool
  default     = false
  description = "Enable AWS Resource Management"
}

variable "enable_optimization" {
  type        = bool
  default     = false
  description = "Enable AWS Optimization by Auto-Stopping"
}

variable "enable_governance" {
  type        = bool
  default     = false
  description = "Enable AWS Asset Governance"
}

variable "enable_commitment_read" {
  type        = bool
  default     = false
  description = "Enable AWS Commitment Orchestrator Read"
}

variable "enable_commitment_write" {
  type        = bool
  default     = false
  description = "Enable AWS Commitment Orchestrator Write"
}

variable "enable_cmk_ebs" {
  type        = bool
  default     = false
  description = "Enable CMK KMS permissions for EBS"
}

variable "enable_autostopping_elb" {
  type        = bool
  default     = false
  description = "Enable AutoStopping permissions for ELB"
}

variable "enable_autostopping_ec2" {
  type        = bool
  default     = false
  description = "Enable AutoStopping permissions for EC2"
}

variable "enable_autostopping_asg_ecs_rds" {
  type        = bool
  default     = false
  description = "Enable AutoStopping permissions for ASG, ECS and RDS"
}

variable "governance_policy_arns" {
  type        = list(string)
  default     = []
  description = "Policy arns to give role access to enforce governance"
}

variable "prefix" {
  type        = string
  description = "A string to add to all resources to add uniqueness"
  default     = ""
}

variable "additional_external_ids" {
  type        = list(string)
  description = "Additional external ids to allow"
  default     = []
}

variable "secrets" {
  type        = list(string)
  description = "List of secrets that harness should have access to"
  default     = []
}
