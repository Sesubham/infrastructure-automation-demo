output "app_data_bucket_name" {
  description = "Name of the S3 bucket for application data"
  value       = aws_s3_bucket.app_data.bucket
}

output "app_data_bucket_arn" {
  description = "ARN of the S3 bucket for application data"
  value       = aws_s3_bucket.app_data.arn
}

output "logs_bucket_name" {
  description = "Name of the S3 bucket for logs"
  value       = aws_s3_bucket.logs.bucket
}

output "logs_bucket_arn" {
  description = "ARN of the S3 bucket for logs"
  value       = aws_s3_bucket.logs.arn
}
