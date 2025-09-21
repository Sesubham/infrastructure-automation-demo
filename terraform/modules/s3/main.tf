resource "aws_s3_bucket" "app_data" {
  bucket = "${var.project_name}-${var.environment}-data-${var.account_id}"
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-data"
    Environment = var.environment
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  
  rule {
    id     = "delete_old_versions"
    status = "Enabled"
    
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
  
  rule {
    id     = "transition_to_ia"
    status = "Enabled"
    
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    
    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

# S3 Bucket for logs
resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-${var.environment}-logs-${var.account_id}"
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-logs"
    Environment = var.environment
  }
}

# S3 Bucket Encryption for logs
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# S3 Bucket Public Access Block for logs
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Lifecycle Configuration for logs
resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  
  rule {
    id     = "delete_old_logs"
    status = "Enabled"
    
    expiration {
      days = 365
    }
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
  
  rule {
    id     = "transition_logs"
    status = "Enabled"
    
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}
