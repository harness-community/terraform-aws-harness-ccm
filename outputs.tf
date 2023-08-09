output "cross_account_role" {
  value = aws_iam_role.harness_ce.arn
}

output "external_id" {
  value = var.external_id
}