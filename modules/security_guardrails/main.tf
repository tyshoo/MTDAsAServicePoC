# Enable AWS Config Recorder
resource "aws_config_configuration_recorder" "recorder" {
  name     = "${var.environment}-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

# IAM Role for Config Recorder
resource "aws_iam_role" "config_role" {
  name = "${var.environment}-config-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "config.amazonaws.com" }
    }]
  })
}

# Attach AWS managed policy
resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

# Start recording
resource "aws_config_configuration_recorder_status" "recorder_status" {
  name     = aws_config_configuration_recorder.recorder.name
  is_enabled = true
}

# Config Rule: S3 bucket encryption enabled
resource "aws_config_config_rule" "s3_encryption" {
  name = var.config_rule_name  # USER INPUT

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  # Scope it to our agent bucket
  scope {
    compliance_resource_types = ["AWS::S3::Bucket"]
    tag_key                  = "Name"
    tag_value                = var.environment != "" ? "${var.environment}-agent-bucket" : null
  }

  depends_on = [aws_config_configuration_recorder.recorder_status]
}

# CloudTrail for audit
resource "aws_cloudtrail" "trail" {
  name                          = var.cloudtrail_name  # USER INPUT
  is_multi_region_trail         = false
  include_global_service_events = true
  enable_log_file_validation    = true

  s3_bucket_name = aws_s3_bucket.trail_bucket.id
}

# S3 bucket for CloudTrail logs
resource "aws_s3_bucket" "trail_bucket" {
  bucket = "${var.environment}-cloudtrail-logs"  # USER INPUT if you want
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

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-cloudtrail-logs"
  }
}
