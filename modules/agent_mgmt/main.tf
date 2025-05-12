# S3 bucket for agent binaries
resource "aws_s3_bucket" "agent_bucket" {
  bucket = var.agent_bucket_name
  acl    = "private"

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-agent-bucket"
  }
}

# Enable versioning so we can roll back to prior agent versions
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.agent_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# (Optional PoC object) placeholder upload
resource "aws_s3_bucket_object" "agent_placeholder" {
  bucket = aws_s3_bucket.agent_bucket.id
  key    = "${var.environment}/agent_v0.1.0.bin"
  # File path is local PoC stub; replace with your actual binary path
  source = "${path.module}/stub/agent_v0.1.0.bin"
  etag   = filemd5("${path.module}/stub/agent_v0.1.0.bin")
}
