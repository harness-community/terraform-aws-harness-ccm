variable "s3_bucket_arn" {
  type        = string
  description = "S3 Arn for the bucket that holds your CUR"
  default     = ""
}

variable "external_id" {
  type        = string
  description = "External ID given in the harness UI: harness:891928451355:<guid>"
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

variable "enable_autostopping_asg_rds_lambda" {
  type        = bool
  default     = false
  description = "Enable AutoStopping permissions for ASG, RDS, and Lambda"
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
