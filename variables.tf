variable "external_id" {
  type        = string
  description = "External ID given in the harness UI: harness:891928451355:<guid>"
}

variable "enable_billing" {
  type        = bool
  default     = true
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
