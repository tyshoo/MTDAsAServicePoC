
# USER INPUT: No changes below unless you want custom ACL or versioning behavior

resource "aws_s3_bucket" "agent_bucket" {
  bucket = var.agent_bucket_name  # USER INPUT via variable.tf
  acl    = "private"

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-agent-bucket"
  }
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
