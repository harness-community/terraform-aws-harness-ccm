variable "s3_bucket_arn" {
  type        = string
  description = "S3 Arn for the bucket that holds your CUR"
  default     = ""
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  # You can set a default value here if needed
  default     = "891928451355"
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
