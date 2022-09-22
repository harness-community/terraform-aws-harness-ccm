data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "harness_ccm" {
  bucket = "harness-ccm-${data.aws_caller_identity.current.account_id}-us-east-1"
}

resource "aws_s3_bucket_acl" "harness_ccm" {
  bucket = aws_s3_bucket.harness_ccm.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "harness_ccm" {
  bucket = aws_s3_bucket.harness_ccm.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "harness_ccm" {
  bucket = aws_s3_bucket.harness_ccm.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "harness_ccm" {
  statement {
    sid = "1"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy"
    ]

    resources = [
      aws_s3_bucket.harness_ccm.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cur:us-east-1:759984737373:definition/*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        "759984737373"
      ]
    }
  }

  statement {
    sid = "2"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.harness_ccm.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cur:us-east-1:759984737373:definition/*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        "759984737373"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "harness_ccm" {
  bucket = aws_s3_bucket.harness_ccm.id
  policy = data.aws_iam_policy_document.harness_ccm.json
}

resource "aws_cur_report_definition" "harness_ccm" {
  report_name                = "harness-ccm"
  time_unit                  = "HOURLY"
  format                     = "textORcsv"
  compression                = "GZIP"
  additional_schema_elements = ["RESOURCES"]
  refresh_closed_reports     = true
  report_versioning          = "OVERWRITE_REPORT"
  s3_bucket                  = aws_s3_bucket.harness_ccm.bucket
  s3_region                  = "us-east-1"
}