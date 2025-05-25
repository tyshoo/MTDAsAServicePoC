data "aws_region" "current" {}

################################################
# IAM Role for AWS Config Recorder (least-privilege)
################################################
resource "aws_iam_role" "config_role" {
  name = "${var.environment}-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "config.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_policy" "config_policy" {
  name        = "${var.environment}-config-policy"
  description = "Permits AWS Config to record resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:GetBucketLogging"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::${var.environment}-cloudtrail-logs/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = aws_iam_policy.config_policy.arn
}

################################################
# AWS Config Recorder
################################################
resource "aws_config_configuration_recorder" "recorder" {
  name     = "${var.environment}-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
  tags = var.common_tags
}

resource "aws_config_configuration_recorder_status" "status" {
  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = true
}

################################################
# Config Rule: S3 Encryption
################################################
resource "aws_config_config_rule" "s3_encryption" {
  name = var.config_rule_name

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
  }

  depends_on = [aws_config_configuration_recorder_status.status]
  tags       = var.common_tags
}

################################################
# CloudWatch Alarm: Config NON_COMPLIANT
################################################
resource "aws_cloudwatch_metric_alarm" "config_noncompliant" {
  alarm_name          = "${var.environment}-config-noncompliant"
  alarm_description   = "Alarm when any AWS Config rule is NON_COMPLIANT"
  namespace           = "AWS/Config"
  metric_name         = "ComplianceSummaryByConfigRule"
  # 1 = Non-Compliant count > 0
  dimensions = {
    ConfigRuleName = aws_config_config_rule.s3_encryption.name
  }
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  tags                = var.common_tags
}

################################################
# SNS Topic for Security Alerts
################################################
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-sec-alerts"
  tags = var.common_tags
}

################################################
# Multi‑Region CloudTrail
################################################
resource "aws_s3_bucket" "trail_bucket" {
  bucket = "${var.environment}-cloudtrail-logs"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.common_tags
}

resource "aws_cloudtrail" "trail" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  tags = var.common_tags
}
