# outputs for the S3 bucket and DynamoDB table created for Terraform remote state management
output "s3_bucket_name" {
  description = "The name of the S3 bucket created for storing Terraform remote state"
  value       = aws_s3_bucket.remote_state_bucket.bucket
}

# outputs for s3 bucket region
output "s3_bucket_region" {
  description = "The AWS region where the S3 bucket for Terraform remote state is created"
  value       = aws_s3_bucket.remote_state_bucket.region
}