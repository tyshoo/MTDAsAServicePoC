################################################
# S3 bucket for agent binaries
################################################

# USER INPUT: No changes below unless you want custom ACL or versioning behavior

resource "aws_s3_bucket" "agent_bucket" {
  bucket = var.agent_bucket_name  # USER INPUT via variable.tf
  acl    = "private"

# Enterprise‐grade tagging
  tags = merge(
    var.common_tags,
    { Name = "${var.environment}-agent-bucket" }
  )
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.agent_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# PoC placeholder binary upload
# USER INPUT: Replace this stub file with your actual agent binary in modules/agent_mgmt/stub/
resource "aws_s3_bucket_object" "agent_placeholder" {
  bucket = aws_s3_bucket.agent_bucket.id
  key    = "${var.environment}/agent_v0.1.0.bin"   # USER INPUT: update version or path as needed
  source = "${path.module}/stub/agent_v0.1.0.bin"   # USER INPUT: ensure this file exists or replace with your binary
  etag   = filemd5("${path.module}/stub/agent_v0.1.0.bin")
}

################################################
# (Optional) CloudWatch alarm on object deletes
################################################
resource "aws_cloudwatch_metric_alarm" "s3_delete_alarm" {
  alarm_name          = "${var.environment}-agent-bucket-delete-alarm"
  alarm_description   = "Alert if objects are deleted from the agent bucket"
  namespace           = "AWS/S3"
  metric_name         = "NumberOfObjects"
  dimensions = {
    BucketName = aws_s3_bucket.agent_bucket.id
    StorageType = "AllStorageTypes"
  }
  statistic           = "SampleCount"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "LessThanThreshold"
  treat_missing_data  = "notBreaching"
  tags                = var.common_tags
}
